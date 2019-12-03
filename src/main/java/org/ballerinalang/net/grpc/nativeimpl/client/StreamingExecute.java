/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc.nativeimpl.client;

import io.netty.handler.codec.http.HttpHeaders;
import org.ballerinalang.jvm.BallerinaValues;
import org.ballerinalang.jvm.TypeChecker;
import org.ballerinalang.jvm.scheduling.Scheduler;
import org.ballerinalang.jvm.types.TypeTags;
import org.ballerinalang.jvm.values.ObjectValue;
import org.ballerinalang.net.grpc.DataContext;
import org.ballerinalang.net.grpc.MethodDescriptor;
import org.ballerinalang.net.grpc.StreamObserver;
import org.ballerinalang.net.grpc.exception.GrpcClientException;
import org.ballerinalang.net.grpc.stubs.DefaultStreamObserver;
import org.ballerinalang.net.grpc.stubs.NonBlockingStub;

import java.util.Map;

import static org.ballerinalang.net.grpc.GrpcConstants.MESSAGE_HEADERS;
import static org.ballerinalang.net.grpc.GrpcConstants.METHOD_DESCRIPTORS;
import static org.ballerinalang.net.grpc.GrpcConstants.PROTOCOL_GRPC_PKG_ID;
import static org.ballerinalang.net.grpc.GrpcConstants.REQUEST_MESSAGE_DEFINITION;
import static org.ballerinalang.net.grpc.GrpcConstants.REQUEST_SENDER;
import static org.ballerinalang.net.grpc.GrpcConstants.SERVICE_STUB;
import static org.ballerinalang.net.grpc.GrpcConstants.STREAMING_CLIENT;
import static org.ballerinalang.net.grpc.Status.Code.INTERNAL;

/**
 * {@code StreamingExecute} is the StreamingExecute action implementation of the gRPC Connector.
 *
 * @since 1.0.0
 */
public class StreamingExecute extends AbstractExecute {

    @SuppressWarnings("unchecked")
    public static Object externStreamingExecute(ObjectValue clientEndpoint, String methodName,
                                           ObjectValue callbackService, Object headerValues) {
        if (clientEndpoint == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connector. gRPC Client connector " +
                    "is not initialized properly");
        }

        Object connectionStub = clientEndpoint.getNativeData(SERVICE_STUB);
        if (connectionStub == null) {
            return notifyErrorReply(INTERNAL, "Error while getting connection stub. gRPC Client connector is " +
                    "not initialized properly");
        }

        if (methodName == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. RPC endpoint doesn't " +
                    "set properly");
        }

        Map<String, MethodDescriptor> methodDescriptors = (Map<String, MethodDescriptor>) clientEndpoint.getNativeData
                (METHOD_DESCRIPTORS);
        if (methodDescriptors == null) {
            return notifyErrorReply(INTERNAL, "Error while processing the request. method descriptors " +
                    "doesn't set properly");
        }

        com.google.protobuf.Descriptors.MethodDescriptor methodDescriptor = methodDescriptors.get(methodName) != null
                ? methodDescriptors.get(methodName).getSchemaDescriptor() : null;
        if (methodDescriptor == null) {
            return notifyErrorReply(INTERNAL, "No registered method descriptor for '" + methodName + "'");
        }

        if (connectionStub instanceof NonBlockingStub) {
            NonBlockingStub nonBlockingStub = (NonBlockingStub) connectionStub;
            HttpHeaders headers = null;
            if (headerValues != null && (TypeChecker.getType(headerValues).getTag() == TypeTags.OBJECT_TYPE_TAG)) {
                headers = (HttpHeaders) ((ObjectValue) headerValues).getNativeData(MESSAGE_HEADERS);
            }

            try {
                MethodDescriptor.MethodType methodType = getMethodType(methodDescriptor);
                DefaultStreamObserver responseObserver = new DefaultStreamObserver(Scheduler.getStrand().scheduler,
                        callbackService);
                StreamObserver requestSender;
                DataContext context = new DataContext(Scheduler.getStrand(), null);
                if (methodType.equals(MethodDescriptor.MethodType.CLIENT_STREAMING)) {
                    requestSender = nonBlockingStub.executeClientStreaming(headers, responseObserver,
                            methodDescriptors.get(methodName), context);
                } else if (methodType.equals(MethodDescriptor.MethodType.BIDI_STREAMING)) {
                    requestSender = nonBlockingStub.executeBidiStreaming(headers, responseObserver, methodDescriptors
                            .get(methodName), context);
                } else {
                    return notifyErrorReply(INTERNAL, "Error while executing the client call. Method type " +
                            methodType.name() + " not supported");
                }
                ObjectValue streamingConnection = BallerinaValues.createObjectValue(PROTOCOL_GRPC_PKG_ID,
                        STREAMING_CLIENT);
                streamingConnection.addNativeData(REQUEST_SENDER, requestSender);
                streamingConnection.addNativeData(REQUEST_MESSAGE_DEFINITION, methodDescriptor
                        .getInputType());
                return streamingConnection;
            } catch (RuntimeException | GrpcClientException e) {
                return notifyErrorReply(INTERNAL, "gRPC Client Connector Error :" + e.getMessage());
            }
        } else {
            return notifyErrorReply(INTERNAL, "Error while processing the request message. Connection Sub " +
                    "type not supported");
        }
    }
}

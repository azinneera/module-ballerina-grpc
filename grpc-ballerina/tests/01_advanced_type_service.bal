// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

listener Listener ep = new (9091, {
    host:"localhost"
});

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_1,
    descMap: getDescriptorMap1()
}
service "HelloWorld" on ep {

    isolated remote function testInputNestedStruct(HelloWorldStringCaller caller, Person req) {
        io:println("name: " + req.name);
        string message = "Submitted name: " + req.name;
        io:println("Response message " + message);
        Error? err = caller->sendString(message);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }

    isolated remote function testOutputNestedStruct(HelloWorldPersonCaller caller, string name) {
        io:println("requested name: " + name);
        Person person = {name:"Sam", address:{postalCode:10300, state:"CA", country:"USA"}};
        io:println(person);
        Error? err = caller->sendPerson(person);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }

    isolated remote function testInputStructOutputStruct(HelloWorldStockQuoteCaller caller, StockRequest req) {
        io:println("Getting stock details for symbol: " + req.name);
        StockQuote res = {symbol:"WSO2", name:"WSO2.com", last:149.52, low:150.70, high:149.18};
        io:println(res);
        Error? err = caller->sendStockQuote(res);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }

    isolated remote function testInputStructNoOutput(HelloWorldNilCaller caller, StockQuote req) {
        io:println("Symbol: " + req.symbol);
        io:println("Name: " + req.name);
        io:println("Last: " + req.last.toString());
        io:println("Low: " + req.low.toString());
        io:println("High: " + req.high.toString());
    }

    isolated remote function testNoInputOutputStruct(HelloWorldStockQuotesCaller caller) {
        StockQuote res = {symbol:"WSO2", name:"WSO2 Inc.", last:14.0, low:15.0, high:16.0};
        StockQuote res1 = {symbol:"Google", name:"Google Inc.", last:100.0, low:101.0, high:102.0};
        StockQuotes quotes = {stock:[res, res1]};

        Error? err = caller->sendStockQuotes(quotes);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }

    isolated remote function testNoInputOutputArray(HelloWorldStockNamesCaller caller) {
        string[] names = ["WSO2", "Google"];
        StockNames stockNames = {names:names};
        Error? err = caller->sendStockNames(stockNames);
        if (err is Error) {
            io:println("Error from Connector: " + err.message());
        }
        checkpanic caller->complete();
    }
}

public client class HelloWorldStringCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendString(string response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextString(ContextString response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorldNilCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorldPersonCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendPerson(Person response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextPerson(ContextPerson response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorldStockNamesCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendStockNames(StockNames response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextStockNames(ContextStockNames response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorldStockQuotesCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendStockQuotes(StockQuotes response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextStockQuotes(ContextStockQuotes response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public client class HelloWorldStockQuoteCaller {
    private Caller caller;

    public isolated function init(Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }
    
    isolated remote function sendStockQuote(StockQuote response) returns Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextStockQuote(ContextStockQuote response) returns Error? {
        return self.caller->send(response);
    }
    
    isolated remote function sendError(Error response) returns Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns Error? {
        return self.caller->complete();
    }
}

public type Person record {
    string name = "";
    Address address = {};
};

public type Address record {
    int postalCode = 0;
    string state = "";
    string country = "";
};

public type StockQuote record {
    string symbol = "";
    string name = "";
    float last = 0.0;
    float low = 0.0;
    float high = 0.0;
};

public type StockRequest record {
    string name = "";
};

public type StockQuotes record {
    StockQuote[] stock = [];
};

public type StockNames record {
    string[] names = [];
};

public type ContextStockRequest record {|
    StockRequest content;
    map<string|string[]> headers;
|};

public type ContextStockQuote record {|
    StockQuote content;
    map<string|string[]> headers;
|};

public type ContextStockQuotes record {|
    StockQuotes content;
    map<string|string[]> headers;
|};

public type ContextPerson record {|
    Person content;
    map<string|string[]> headers;
|};

public type ContextStockNames record {|
    StockNames content;
    map<string|string[]> headers;
|};

const string ROOT_DESCRIPTOR_1 = "0A1E30315F616476616E6365645F747970655F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F224D0A06506572736F6E12120A046E616D6518012001280952046E616D65122F0A076164647265737318022001280B32152E6772706373657276696365732E4164647265737352076164647265737322590A0741646472657373121E0A0A706F7374616C436F6465180120012805520A706F7374616C436F646512140A0573746174651802200128095205737461746512180A07636F756E7472791803200128095207636F756E74727922720A0A53746F636B51756F746512160A0673796D626F6C180120012809520673796D626F6C12120A046E616D6518022001280952046E616D6512120A046C61737418032001280252046C61737412100A036C6F7718042001280252036C6F7712120A046869676818052001280252046869676822220A0C53746F636B5265717565737412120A046E616D6518012001280952046E616D65223D0A0B53746F636B51756F746573122E0A0573746F636B18012003280B32182E6772706373657276696365732E53746F636B51756F7465520573746F636B22220A0A53746F636B4E616D657312140A056E616D657318012003280952056E616D657332E3030A0A48656C6C6F576F726C64124B0A1574657374496E7075744E657374656453747275637412142E6772706373657276696365732E506572736F6E1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124C0A16746573744F75747075744E6573746564537472756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A142E6772706373657276696365732E506572736F6E12530A1B74657374496E7075745374727563744F7574707574537472756374121A2E6772706373657276696365732E53746F636B526571756573741A182E6772706373657276696365732E53746F636B51756F7465124B0A1774657374496E7075745374727563744E6F4F757470757412182E6772706373657276696365732E53746F636B51756F74651A162E676F6F676C652E70726F746F6275662E456D707479124C0A17746573744E6F496E7075744F757470757453747275637412162E676F6F676C652E70726F746F6275662E456D7074791A192E6772706373657276696365732E53746F636B51756F746573124A0A16746573744E6F496E7075744F7574707574417272617912162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E53746F636B4E616D6573620670726F746F33";
isolated function getDescriptorMap1() returns map<string> {
    return {
        "01_advanced_type_service.proto":"0A1E30315F616476616E6365645F747970655F736572766963652E70726F746F120C6772706373657276696365731A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F224D0A06506572736F6E12120A046E616D6518012001280952046E616D65122F0A076164647265737318022001280B32152E6772706373657276696365732E4164647265737352076164647265737322590A0741646472657373121E0A0A706F7374616C436F6465180120012805520A706F7374616C436F646512140A0573746174651802200128095205737461746512180A07636F756E7472791803200128095207636F756E74727922720A0A53746F636B51756F746512160A0673796D626F6C180120012809520673796D626F6C12120A046E616D6518022001280952046E616D6512120A046C61737418032001280252046C61737412100A036C6F7718042001280252036C6F7712120A046869676818052001280252046869676822220A0C53746F636B5265717565737412120A046E616D6518012001280952046E616D65223D0A0B53746F636B51756F746573122E0A0573746F636B18012003280B32182E6772706373657276696365732E53746F636B51756F7465520573746F636B22220A0A53746F636B4E616D657312140A056E616D657318012003280952056E616D657332E3030A0A48656C6C6F576F726C64124B0A1574657374496E7075744E657374656453747275637412142E6772706373657276696365732E506572736F6E1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124C0A16746573744F75747075744E6573746564537472756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A142E6772706373657276696365732E506572736F6E12530A1B74657374496E7075745374727563744F7574707574537472756374121A2E6772706373657276696365732E53746F636B526571756573741A182E6772706373657276696365732E53746F636B51756F7465124B0A1774657374496E7075745374727563744E6F4F757470757412182E6772706373657276696365732E53746F636B51756F74651A162E676F6F676C652E70726F746F6275662E456D707479124C0A17746573744E6F496E7075744F757470757453747275637412162E676F6F676C652E70726F746F6275662E456D7074791A192E6772706373657276696365732E53746F636B51756F746573124A0A16746573744E6F496E7075744F7574707574417272617912162E676F6F676C652E70726F746F6275662E456D7074791A182E6772706373657276696365732E53746F636B4E616D6573620670726F746F33",
        "google/protobuf/empty.proto":"0A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F120F676F6F676C652E70726F746F62756622070A05456D70747942760A13636F6D2E676F6F676C652E70726F746F627566420A456D70747950726F746F50015A276769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F656D707479F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C7565427C0A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A2A6769746875622E636F6D2F676F6C616E672F70726F746F6275662F7074797065732F7772617070657273F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}

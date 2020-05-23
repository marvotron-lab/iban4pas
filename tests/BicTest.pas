{*
 * Copyright 2013 Artur Mkrtchyan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
   Pascal port Copyright 2020 yonojoy@gmail.com
 }
unit BicTest;

interface

uses
    System.SysUtils,
    TestFrameWork,
    BaseTestCase,
    Iban4Pas.Bic,
    Iban4Pas.CountryCode;

type
    TBicCreationTest1 = class(TBaseTestCase)
    published
        procedure bicConstructionWithInvalidCountryCodeShouldThrowException();
        procedure bicShouldReturnBankCode;
        procedure bicShouldReturnBranchCode;
        procedure bicShouldReturnCountryCode;
        procedure bicShouldReturnLocationCode;
        procedure bicsWithDifferentDataShouldNotBeEqual;
        procedure bicsWithSameDataShouldBeEqual;
        procedure bicToStringShouldReturnString;
        procedure bicWithoutBranchCodeShouldReturnNull;
    end;

    TBicCreationTest2 = class(TBaseTestCase)
    published
        procedure bicConstructionWithValueOfShouldReturnBic;
//    function bicParameters: TArray<string>;
    end;

implementation

uses
    TestDataHelper;

procedure TBicCreationTest1.bicConstructionWithInvalidCountryCodeShouldThrowException;
begin
    CheckException(
        procedure
        begin
            TBic.valueOf('DEUTAAFF500');
        end,
        EUnsupportedCountryException, 'country code AA');
end;


procedure TBicCreationTest1.bicsWithSameDataShouldBeEqual();
var
    bic1: IBic;
    bic2: IBic;
begin
    bic1 := TBic.valueOf('DEUTDEFF500');
    bic2 := TBic.valueOf('DEUTDEFF500');

    Check(bic1.equals(bic2));
end;

procedure TBicCreationTest1.bicsWithDifferentDataShouldNotBeEqual();
var
    bic1: IBic;
    bic2: IBic;
begin
    bic1 := TBic.valueOf('DEUTDEFF500');
    bic2 := TBic.valueOf('DEUTDEFF501');

    Check(not bic1.equals(bic2));
end;


//procedure TBicCreationTest1.bicsWithSameDataShouldHaveSameHashCode(); begin
//    Bic bic1 = Bic.valueOf('DEUTDEFF500');
//    Bic bic2 = Bic.valueOf('DEUTDEFF500');
//
//    assertThat(bic1.hashCode(), is(equalTo(bic2.hashCode())));
//end;

//procedure TBicCreationTest1.bicsWithDifferentDataShouldNotHaveSameHashCode(); begin
//    Bic bic1 = Bic.valueOf('DEUTDEFF500');
//    Bic bic2 = Bic.valueOf('DEUTDEFF501');
//
//    assertThat(bic1.hashCode(), is(not(equalTo(bic2.hashCode()))));
//end;

procedure TBicCreationTest1.bicShouldReturnBankCode();
var
    bic: IBic;
begin
    bic := TBic.valueOf('DEUTDEFF500');

    Check(bic.getBankCode() = 'DEUT');
end;

procedure TBicCreationTest1.bicShouldReturnCountryCode();
var
    bic: IBic;
begin
    bic := TBic.valueOf('DEUTDEFF500');

    Check(bic.getCountryCode() = TCountryCode.DE);
end;

procedure TBicCreationTest1.bicShouldReturnBranchCode();
var
    bic: IBic;
begin
    bic := TBic.valueOf('DEUTDEFF500');

    Check(bic.getBranchCode() = '500');
end;


procedure TBicCreationTest1.bicWithoutBranchCodeShouldReturnNull();
var
    bic: IBic;
begin
    bic := TBic.valueOf('DEUTDEFF');

    Check(bic.getBranchCode() = '');
end;


procedure TBicCreationTest1.bicShouldReturnLocationCode();
var
    bic: IBic;
begin
    bic := TBic.valueOf('DEUTDEFF500');

    Check(bic.getLocationCode() = 'FF');
end;


procedure TBicCreationTest1.bicToStringShouldReturnString();
var
    bic: IBic;
begin
    bic := TBic.valueOf('DEUTDEFF500');

    Check(bic.toString() = 'DEUTDEFF500');
end;


procedure TBicCreationTest2.bicConstructionWithValueOfShouldReturnBic();
var
    bicString: string;
begin
    for bicString in TTestDataHelper.BIC_DATA do
      Check(Assigned(TBic.valueOf(bicString)), 'Check of ' + bicString);
end;


initialization
    RegisterTest(TBicCreationTest1.Suite);
    RegisterTest(TBicCreationTest2.Suite);

end.

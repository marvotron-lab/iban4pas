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
unit BicUtilTest;

interface

uses
    System.SysUtils,
    TestFrameWork,
    BaseTestCase,
    Iban4Pas.BicUtil,
    Iban4Pas.CountryCode;

type
    TInvalidBicValidationTest = class(TBaseTestCase)
    published
        procedure bicValidationWithEmptyStringShouldThrowException;
        procedure bicValidationWithInvalidBankCodeShouldThrowException;
        procedure bicValidationWithInvalidBranchCodeShouldThrowException;
        procedure bicValidationWithInvalidCountryCodeShouldThrowException;
        procedure bicValidationWithInvalidLocationCodeShouldThrowException;
        procedure bicValidationWithLessCharactersShouldThrowException;
        procedure bicValidationWithLowercaseShouldThrowException;
        procedure bicValidationWithMoreCharactersShouldThrowException;
        procedure bicValidationWithNonExistingCountryCodeShouldThrowException;
    end;

implementation


procedure TInvalidBicValidationTest.bicValidationWithEmptyStringShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Empty string can't be a valid Bic'));
    TBicUtil.validate('');
end;


procedure TInvalidBicValidationTest.bicValidationWithLessCharactersShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Bic length must be 8 or 11'));
    TBicUtil.validate('DEUTFF');
end;


procedure TInvalidBicValidationTest.bicValidationWithMoreCharactersShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Bic length must be 8 or 11'));
    TBicUtil.validate('DEUTFFDEUTFF');
end;


procedure TInvalidBicValidationTest.bicValidationWithLowercaseShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Bic must contain only upper case letters'));
    TBicUtil.validate('DEUTdeFF');
end;


procedure TInvalidBicValidationTest.bicValidationWithInvalidBankCodeShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Bank code must contain only letters'));
    TBicUtil.validate('DEU1DEFF');
end;


procedure TInvalidBicValidationTest.bicValidationWithNonExistingCountryCodeShouldThrowException();
begin
    StartExpectingException(EUnsupportedCountryException);
//    expectedException.expectMessage(containsString('Country code is not supported'));
    TBicUtil.validate('DEUTDDFF');
end;


procedure TInvalidBicValidationTest.bicValidationWithInvalidCountryCodeShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Bic country code must contain upper case letters'));
    TBicUtil.validate('DEUT_1FF');
end;


procedure TInvalidBicValidationTest.bicValidationWithInvalidLocationCodeShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Location code must contain only letters or digits'));
    TBicUtil.validate('DEUTDEF ');
end;


procedure TInvalidBicValidationTest.bicValidationWithInvalidBranchCodeShouldThrowException();
begin
    StartExpectingException(EBicFormatException);
//    expectedException.expectMessage(containsString('Branch code must contain only letters or digits'));
    TBicUtil.validate('DEUTDEFF50_');
end;


initialization
    RegisterTest(TInvalidBicValidationTest.Suite);

end.

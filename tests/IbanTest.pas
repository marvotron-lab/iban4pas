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
unit IbanTest;

interface

{
    TODO:
    * parameterized tests
}

uses
    System.SysUtils,
    TestFrameWork,
    BaseTestCase,
    Iban4Pas.CountryCode,
    Iban4Pas.Iban,
    TestDataHelper;

type
    //parameterized Tests
    TIbanGenerationTest1 = class(TBaseTestCase)
    published
        procedure ibanConstructionWithSupportedCountriesShouldReturnIban;
        procedure ibanConstructionWithValueOfShouldReturnIban;
    end;

    TIbanGenerationTest2 = class(TBaseTestCase)
    private
        iban1: IIban;
        iban2: IIban;
        iban: IIban;
    published
        procedure ibanConstructionWithDefaultFormattingShouldReturnIban;
        procedure ibanConstructionWithNoneFormattingShouldReturnIban;
        procedure ibanConstructionWithShortBankCodeShouldNotThrowExceptionIfValidationIsDisabled;
        procedure ibanShouldReturnValidAccountNumber;
        procedure ibanShouldReturnValidAccountType;
        procedure ibanShouldReturnValidBankCode;
        procedure ibanShouldReturnValidBban;
        procedure ibanShouldReturnValidBranchCode;
        procedure ibanShouldReturnValidCheckDigit;
        procedure ibanShouldReturnValidCountryCode;
        procedure ibanShouldReturnValidIdentificationNumber;
        procedure ibanShouldReturnValidNationalCheckDigit;
        procedure ibanShouldReturnValidOwnerAccountType;
        procedure ibansWithDifferentDataShouldNotBeEqual;
        procedure ibansWithSameDataShouldBeEqual;
        procedure ibanAndStringShouldBeEqual;
        procedure ibanToFormattedStringShouldHaveSpacesAfterEach4Character;
    end;

    TIbanGenerationExceptionalTest = class(TBaseTestCase)
    published
        procedure formattedIbanConstructionWithNoneFormatShouldThrowException;
        procedure ibanConstructionWithDefaultButInvalidFormatShouldThrowException;
        procedure ibanConstructionWithInvalidBbanCharacterShouldThrowException;
        procedure ibanConstructionWithInvalidCharacterShouldThrowException;
        procedure ibanConstructionWithInvalidCheckDigitShouldThrowException;
        procedure ibanConstructionWithInvalidCountryShouldThrowException;
        procedure ibanConstructionWithNonSupportedCountryShouldThrowException;
        procedure ibanConstructionWithNullStringShouldThrowException;
        procedure ibanConstructionWithoutAccountNumberShouldThrowException;
        procedure ibanConstructionWithoutBankCodeShouldThrowException;
        procedure ibanConstructionWithoutCountryShouldThrowException;
        procedure ibanConstructionWithShortBankCodeShouldThrowException;
        procedure ibanConstructionWithShortBankCodeShouldThrowExceptionIfValidationRequested;
        procedure unformattedIbanConstructionWithDefaultFormatShouldThrowException;
    end;


implementation

procedure TIbanGenerationTest1.ibanConstructionWithSupportedCountriesShouldReturnIban();
var
    IbanAndStr: TIbanStr;
begin
    for IbanAndStr in TTestDataHelper.getIbanData() do
      Check(IbanAndStr.Key.toString() = IbanAndStr.Value, 'Check for ' + IbanAndStr.Value);
end;

procedure TIbanGenerationTest1.ibanConstructionWithValueOfShouldReturnIban();
var
    IbanAndStr: TIbanStr;
begin
    for IbanAndStr in TTestDataHelper.getIbanData() do
      Check(TIban.valueOf(IbanAndStr.Value).equals(IbanAndStr.Key), 'Check for ' + IbanAndStr.Value);
end;


procedure TIbanGenerationTest2.ibansWithSameDataShouldBeEqual();
begin
    iban1 := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('102345732012')
            .build();
    iban2 := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('102345732012')
            .build();

    Check(iban1.equals(iban2));
end;


procedure TIbanGenerationTest2.ibansWithDifferentDataShouldNotBeEqual();
begin
    iban1 := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('102345732012')
            .build();
    iban2 := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('102345732011')
            .build();

    Check(not iban1.equals(iban2));
end;


//original: ibansWithStringValueAndIbanShouldNotBeEqual is irrelevant for Delphi implementation
procedure TIbanGenerationTest2.ibanAndStringShouldBeEqual();
begin
    iban1 := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('19043')
            .accountNumber('00234573201')
            .build();

    Check(iban1.toString() = 'AT611904300234573201');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidCountryCode();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('19043')
            .accountNumber('00234573201')
            .build();

    Check(iban.getCountryCode() = TCountryCode.AT);
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidBankCode();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('19043')
            .accountNumber('00234573201')
            .build();

    Check(iban.getBankCode() = '19043');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidAccountNumber();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('19043')
            .accountNumber('00234573201')
            .build();

    Check(iban.getAccountNumber() = '00234573201');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidBranchCode();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AD)
            .bankCode('0001')
            .branchCode('2030')
            .accountNumber('200359100100')
            .build();

    Check(iban.getBranchCode() = '2030');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidNationalCheckDigit();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AL)
            .bankCode('212')
            .branchCode('1100')
            .nationalCheckDigit('9')
            .accountNumber('0000000235698741')
            .build();
    Check(iban.getNationalCheckDigit() = '9');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidAccountType();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.BR)
            .bankCode('00360305')
            .branchCode('00001')
            .accountNumber('0009795493')
            .accountType('P')
            .ownerAccountType('1')
            .build();
    Check(iban.getAccountType() = 'P');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidOwnerAccountType();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.BR)
            .bankCode('00360305')
            .branchCode('00001')
            .accountNumber('0009795493')
            .accountType('P')
            .ownerAccountType('1')
            .build();
    Check(iban.getOwnerAccountType() = '1');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidIdentificationNumber();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.IS_)
            .bankCode('0159')
            .branchCode('26')
            .accountNumber('007654')
            .identificationNumber('5510730339')
            .build();
    Check(iban.getIdentificationNumber() = '5510730339');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidBban();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('19043')
            .accountNumber('00234573201')
            .build();

    Check(iban.getBban() = '1904300234573201');
end;


procedure TIbanGenerationTest2.ibanShouldReturnValidCheckDigit();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('19043')
            .accountNumber('00234573201')
            .build();

    Check(iban.getCheckDigit() = '61');
end;


//procedure TIbanGenerationTest2.ibansWithSameDataShouldHaveSameHashCode();
//begin
//    iban1 := TIban.Builder()
//            .countryCode(TCountryCode.AT)
//            .bankCode('1904')
//            .accountNumber('102345732012')
//            .build();
//    iban2 := TIban.Builder()
//            .countryCode(TCountryCode.AT)
//            .bankCode('1904')
//            .accountNumber('102345732012')
//            .build();
//
//    Check(iban1.hashCode() = iban2.hashCode());
//end;


//procedure TIbanGenerationTest2.ibansWithDifferentDataShouldNotHaveSameHashCode();
//    iban1 := TIban.Builder()
//            .countryCode(TCountryCode.AT)
//            .bankCode('1904')
//            .accountNumber('102345732012')
//            .build();
//    iban2 := TIban.Builder()
//            .countryCode(TCountryCode.AT)
//            .bankCode('1904')
//            .accountNumber('102345732011')
//            .build();
//
//    Check(iban1.hashCode(), is(not(equalTo(iban2.hashCode()))));
//end;


procedure TIbanGenerationTest2.ibanToFormattedStringShouldHaveSpacesAfterEach4Character();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('102345732012')
            .build();
    Check(iban.toFormattedString() = 'AT14 1904 1023 4573 2012');
end;


procedure TIbanGenerationTest2.ibanConstructionWithShortBankCodeShouldNotThrowExceptionIfValidationIsDisabled();
begin
    iban := TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('A0234573201')
            .build(false);
    Check(iban.toFormattedString() = 'AT40 1904 A023 4573 201');
end;


procedure TIbanGenerationTest2.ibanConstructionWithNoneFormattingShouldReturnIban();
begin
    iban := TIban.valueOf('AT611904300234573201', TIbanFormat.None);
    Check(iban.toFormattedString() = 'AT61 1904 3002 3457 3201');
end;


procedure TIbanGenerationTest2.ibanConstructionWithDefaultFormattingShouldReturnIban();
begin
    iban := TIban.valueOf('AT61 1904 3002 3457 3201', TIbanFormat.Default);
    Check(iban.toFormattedString() = 'AT61 1904 3002 3457 3201');
end;

//(expected = UnsupportedCountryException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithNonSupportedCountryShouldThrowException();
begin
    StartExpectingException(EUnsupportedCountryException);
    TIban.Builder()
            .countryCode(TCountryCode.AM)
            .bankCode('0001')
            .branchCode('2030')
            .accountNumber('200359100100')
            .build();
end;


//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithInvalidCountryShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.valueOf('ZZ018786767');
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithNullStringShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.valueOf('');
end;

//(expected = InvalidCheckDigitException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithInvalidCheckDigitShouldThrowException();
begin
    StartExpectingException(EInvalidCheckDigitException);
    TIban.valueOf('AT621904300234573201');
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithInvalidBbanCharacterShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.valueOf('AZ21NABZ000000001370100_1944');
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithDefaultButInvalidFormatShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.valueOf('AT61 1904 3002 34573201', TIbanFormat.Default);
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.formattedIbanConstructionWithNoneFormatShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.valueOf('AT61 1904 3002 3457 3201', TIbanFormat.None);
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.unformattedIbanConstructionWithDefaultFormatShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.valueOf('AT611904300234573201', TIbanFormat.Default);
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithoutCountryShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.Builder()
            .bankCode('0001')
            .branchCode('2030')
            .accountNumber('200359100100')
            .build();
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithoutBankCodeShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.Builder()
            .countryCode(TCountryCode.AM)
            .branchCode('2030')
            .accountNumber('200359100100')
            .build();
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithoutAccountNumberShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.Builder()
            .countryCode(TCountryCode.AM)
            .bankCode('0001')
            .branchCode('2030')
            .build();
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithInvalidCharacterShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('19043')
            .accountNumber('A0234573201')
            .build();
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithShortBankCodeShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('A0234573201')
            .build();
end;

//(expected = IbanFormatException.class)
procedure TIbanGenerationExceptionalTest.ibanConstructionWithShortBankCodeShouldThrowExceptionIfValidationRequested();
begin
    StartExpectingException(EIbanFormatException);
    TIban.Builder()
            .countryCode(TCountryCode.AT)
            .bankCode('1904')
            .accountNumber('A0234573201')
            .build(true);
end;


//procedure TIbanGenerationExceptionalTest.ibanConstructionRandom();
//begin
//    for (int i = 0; i < 100; i++);
//        TIban.Builder().buildRandom();
//        TIban.random();
//    end;
//end;


//procedure TIbanGenerationExceptionalTest.ibanContructionRandomAcctRetainsSpecifiedCountry();
//begin
//    iban := TIban.Builder().countryCode(TCountryCode.AT).buildRandom();
//    Check(iban.getCountryCode() = TCountryCode.AT)));
//
//    iban = TIban.random(TCountryCode.AT);
//    Check(iban.getCountryCode() = TCountryCode.AT)));
//end;


//procedure TIbanGenerationExceptionalTest.ibanContructionRandomRetainsSpecifiedBankCode();
//begin
//    iban := TIban.Builder()
//            .countryCode(TCountryCode.AT)
//            .bankCode('12345')
//            .buildRandom();
//    Check(iban.getBankCode() = '12345')));
//end;


//procedure TIbanGenerationExceptionalTest.ibanContructionRandomDoesNotOverwriteBankAccount();
//begin
//    iban := TIban.Builder()
//            .countryCode(TCountryCode.AT)
//            .accountNumber('12345678901')
//            .buildRandom();
//    Check(iban.getAccountNumber() = '12345678901')));
//end;


//procedure TIbanGenerationExceptionalTest.ibanContructionRandomDoesNotOverwriteBranchCode();
//begin
//    iban := TIban.Builder()
//            .countryCode(TCountryCode.AL)
//            .branchCode('1234')
//            .buildRandom();
//    Check(iban.getBranchCode() = '1234')));
//end;
//
//
//procedure TIbanGenerationExceptionalTest.ibanContructionRandomDoesNotOverwriteNationalCheckDigit();
//begin
//    iban := TIban.Builder()
//            .countryCode(TCountryCode.AL)
//            .nationalCheckDigit('1')
//            .buildRandom();
//    Check(iban.getNationalCheckDigit() = '1')));
//end;
//
//
//procedure TIbanGenerationExceptionalTest.ibanContructionRandomDoesNotOverwriteAccountType();
//begin
//    iban := TIban.Builder()
//            .countryCode(TCountryCode.BR)
//            .accountType('A')
//            .buildRandom();
//    Check(iban.getAccountType() = 'A')));
//end;
//
//
//procedure TIbanGenerationExceptionalTest.ibanContructionRandomDoesNotOverwriteOwnerAccountType();
//begin
//    iban := TIban.Builder()
//            .countryCode(TCountryCode.BR)
//            .ownerAccountType('C')
//            .buildRandom();
//    Check(iban.getOwnerAccountType() = 'C')));
//end;
//
//
//procedure TIbanGenerationExceptionalTest.ibanContructionRandomDoesNotOverwriteIdentificationNumber();
//begin
//    iban := TIban.Builder()
//            .countryCode(TCountryCode.IS)
//            .identificationNumber('1234567890')
//            .buildRandom();
//    Check(iban.getIdentificationNumber() = '1234567890')));
//end;


initialization
    RegisterTest(TIbanGenerationTest1.Suite);
    RegisterTest(TIbanGenerationTest2.Suite);
    RegisterTest(TIbanGenerationExceptionalTest.Suite);

end.

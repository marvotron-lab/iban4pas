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
unit IbanUtilTest;

interface

{
    TODO:
    * parameterized tests
    * better exception checks
}

uses
    System.SysUtils,
    TestFrameWork,
    BaseTestCase,
    Iban4Pas.CountryCode,
    Iban4Pas.IbanUtil,
    Iban4Pas.Iban;
type

    TValidCheckDigitCalculationTest = class(TBaseTestCase)
    published
        procedure checkDigitCalculationWithCountryCodeAndBbanShouldReturnCheckDigit;
    end;

    TInvalidCheckDigitCalculationTest = class(TBaseTestCase)
    published
        procedure checkDigitCalculationWithNonNumericBbanShouldThrowException;
    end;

    TDefaultIbanUtilTest = class(TBaseTestCase)
    published
        procedure formattedIbanValidationWithDefaultFormattingShouldNotThrowException;
        procedure ibanCountrySupportCheckWithNullShouldReturnFalse;
        procedure ibanCountrySupportCheckWithSupportedCountryShouldReturnTrue;
        procedure ibanCountrySupportCheckWithUnsupportedCountryShouldReturnFalse;
        procedure unformattedIbanValidationWithNoneFormattingShouldNotThrowException;
    end;

    TInvalidIbanValidationTest = class(TBaseTestCase)
    published
        procedure formattedIbanValidationWithNoneFormattingShouldThrowException;
        procedure ibanValidationWithCountryCodeAndCheckDigitOnlyShouldThrowException;
        procedure ibanValidationWithCountryCodeOnlyShouldThrowException;
        procedure ibanValidationWithEmptyCountryShouldThrowException;
        procedure ibanValidationWithEmptyShouldThrowException;
        procedure ibanValidationWithInvalidAccountNumberShouldThrowException;
        procedure ibanValidationWithInvalidBankCodeShouldThrowException;
        procedure ibanValidationWithInvalidBbanLengthShouldThrowException;
        procedure ibanValidationWithInvalidCheckDigitShouldThrowException;
        procedure ibanValidationWithInvalidLengthShouldThrowException;
        procedure ibanValidationWithInvalidNationalCheckDigitShouldThrowException;
        procedure ibanValidationWithLowercaseCountryShouldThrowException;
        procedure ibanValidationWithNonDigitCheckDigitShouldThrowException;
        procedure ibanValidationWithNonExistingCountryShouldThrowException;
        procedure ibanValidationWithNonSupportedCountryShouldThrowException;
        procedure ibanValidationWithOneCharStringShouldThrowException;
        procedure ibanValidationWithSpaceShouldThrowException;
        procedure unformattedIbanValidationWithDefaultFormattingShouldThrowException;
    end;

    TValidIbanValidationTest = class(TBaseTestCase)
    private
        function NON_STANDARD_VALID_IBAN: IIban;
    published
        procedure ibanValidationWithValidIbanShouldNotThrowException;
        procedure ibanValidationWithValidIbanShouldNotThrowExceptionNonStandard;
    end;

implementation

uses
    TestDataHelper;



procedure TValidCheckDigitCalculationTest.checkDigitCalculationWithCountryCodeAndBbanShouldReturnCheckDigit();
var
    checkDigit: string;
    ibanAndStr: TIbanStr;
begin
    for ibanAndStr in TTestDataHelper.getIbanData() do
    begin
        checkDigit := TIbanUtil.calculateCheckDigit(ibanAndStr.Value);
        Check(checkDigit = ibanAndStr.Value.substring(2, 2), 'Check for ' + ibanAndStr.Value);
    end;
end;


//@Test(expected = IbanFormatException.class)
procedure TInvalidCheckDigitCalculationTest.checkDigitCalculationWithNonNumericBbanShouldThrowException();
var
    invalidCharacter: Char;
begin
    for invalidCharacter in  #8556'+' do
    begin
        StartExpectingException(EIbanFormatException); // invalidCharacter);
        TIbanUtil.calculateCheckDigit('AT000159260' + invalidCharacter + '076545510730339');
    end;
end;



procedure TDefaultIbanUtilTest.ibanCountrySupportCheckWithNullShouldReturnFalse();
begin
    Check(TIbanUtil.isSupportedCountry(TCountryCode.UNKNOWN) = false);
end;


procedure TDefaultIbanUtilTest.ibanCountrySupportCheckWithSupportedCountryShouldReturnTrue();
begin
    Check(TIbanUtil.isSupportedCountry(TCountryCode.BE) = true);
end;


procedure TDefaultIbanUtilTest.ibanCountrySupportCheckWithUnsupportedCountryShouldReturnFalse();
begin
    Check(TIbanUtil.isSupportedCountry(TCountryCode.AM) = false);
end;


procedure TDefaultIbanUtilTest.unformattedIbanValidationWithNoneFormattingShouldNotThrowException();
begin
    TIbanUtil.validate('AT611904300234573201', TIbanFormat.None);
end;


procedure TDefaultIbanUtilTest.formattedIbanValidationWithDefaultFormattingShouldNotThrowException();
begin
    TIbanUtil.validate('AT61 1904 3002 3457 3201', TIbanFormat.Default);
end;


//procedure TInvalidIbanValidationTest.ibanValidationWithNullShouldThrowException();
//begin
//    StartExpectingException(EIbanFormatException);
//    //expectedException.expectMessage(containsString('Null can't be a valid Iban'));
//    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.IBAN_NOT_NULL));
//    TIbanUtil.validate('');
//end;


procedure TInvalidIbanValidationTest.ibanValidationWithEmptyShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Empty string can't be a valid Iban'));
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.IBAN_NOT_EMPTY));
    TIbanUtil.validate('');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithOneCharStringShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Iban must contain 2 char country code.'));
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.COUNTRY_CODE_TWO_LETTERS));
    //expectedException.expect(new IbanFormatExceptionActualValueMatcher('A'));
    TIbanUtil.validate('A');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithCountryCodeOnlyShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Iban must contain 2 digit check digit.'));
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.CHECK_DIGIT_TWO_DIGITS));
    //expectedException.expect(new IbanFormatExceptionActualValueMatcher(''));
    TIbanUtil.validate('AT');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithNonDigitCheckDigitShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Iban's check digit should contain only digits.'));
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.CHECK_DIGIT_ONLY_DIGITS));
    //expectedException.expect(new IbanFormatExceptionActualValueMatcher('4T'));
    TIbanUtil.validate('AT4T');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithCountryCodeAndCheckDigitOnlyShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.BBAN_LENGTH));
    //expectedException.expect(new IbanFormatExceptionActualValueMatcher(0));
    //expectedException.expect(new IbanFormatExceptionExpectedValueMatcher(16));
    TIbanUtil.validate('AT48');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithLowercaseCountryShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Iban country code must contain upper case letters'));
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.COUNTRY_CODE_UPPER_CASE_LETTERS));
    //expectedException.expect(new IbanFormatExceptionActualValueMatcher('at'));
    TIbanUtil.validate('at611904300234573201');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithEmptyCountryShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Iban country code must contain upper case letters'));
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.COUNTRY_CODE_UPPER_CASE_LETTERS));
    //expectedException.expect(new IbanFormatExceptionActualValueMatcher(' _'));
    TIbanUtil.validate(' _611904300234573201');
end;

//(expected = UnsupportedCountryException.class)
procedure TInvalidIbanValidationTest.ibanValidationWithNonSupportedCountryShouldThrowException();
begin
    StartExpectingException(EUnsupportedCountryException);
    TIbanUtil.validate('AM611904300234573201');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithNonExistingCountryShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Iban contains non existing country code.'));
    //expectedException.expect(new IbanFormatViolationMatcher(IbanFormatViolation.COUNTRY_CODE_EXISTS));
    TIbanUtil.validate('JJ611904300234573201');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithInvalidCheckDigitShouldThrowException();
begin
    StartExpectingException(EInvalidCheckDigitException);
    //expectedException.expectMessage('invalid check digit: 62');
    //expectedException.expectMessage('expected check digit is: 61');
    //expectedException.expectMessage('AT621904300234573201');
    TIbanUtil.validate('AT621904300234573201');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithSpaceShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage('length is 17');
    //expectedException.expectMessage('expected BBAN length is: 16');
    TIbanUtil.validate('AT61 1904300234573201');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithInvalidLengthShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    TIbanUtil.validate('AT621904300');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithInvalidBbanLengthShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('expected BBAN length is:'));
    TIbanUtil.validate('AT61190430023457320');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithInvalidBankCodeShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('must contain only digits'));
    TIbanUtil.validate('AT611C04300234573201');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithInvalidAccountNumberShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('must contain only digits'));
    TIbanUtil.validate('DE8937040044053201300A');
end;


procedure TInvalidIbanValidationTest.ibanValidationWithInvalidNationalCheckDigitShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('must contain only upper case letters'));
    TIbanUtil.validate('IT6010542811101000000123456');
end;


procedure TInvalidIbanValidationTest.unformattedIbanValidationWithDefaultFormattingShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('Iban must be formatted using 4 characters and space'));
    TIbanUtil.validate('AT611904300234573201', TIbanFormat.Default);
end;


procedure TInvalidIbanValidationTest.formattedIbanValidationWithNoneFormattingShouldThrowException();
begin
    StartExpectingException(EIbanFormatException);
    //expectedException.expectMessage(containsString('expected BBAN length is: 16'));
    TIbanUtil.validate('AT61 1904 3002 3457 3201', TIbanFormat.None);
end;


procedure TValidIbanValidationTest.ibanValidationWithValidIbanShouldNotThrowExceptionNonStandard();
begin
     TIbanUtil.validate(NON_STANDARD_VALID_IBAN.toString);
end;
function TValidIbanValidationTest.NON_STANDARD_VALID_IBAN(): IIban;
begin
    // iban with 98 check digit
    Result := TIban.Builder()
        .countryCode(TCountryCode.TR)
        .bankCode('00123')
        .accountNumber('0882101517977799')
        .nationalCheckDigit('0')
        .build();
    Check(Result.toString() = 'TR980012300882101517977799');
end;

//some tests from parameterized
procedure TValidIbanValidationTest.ibanValidationWithValidIbanShouldNotThrowException();
begin
    CheckNoException(
        procedure
        begin
            TIbanUtil.validate('AL47212110090000000235698741');
        end,
        'AL47212110090000000235698741');
    TIbanUtil.validate('AD1200012030200359100100');
    TIbanUtil.validate('AT611904300234573201');
    TIbanUtil.validate('AZ21NABZ00000000137010001944');
    TIbanUtil.validate('BH72SCBLBHD18903608801');
end;


//TODO parameterized tests
(*
    @RunWith(Parameterized.class)
    public static class ValidIbanValidationTest {

        private final String ibanString;

        public ValidIbanValidationTest(Iban iban, String ibanString);
            this.ibanString = ibanString;
        end;


        public void ibanValidationWithValidIbanShouldNotThrowException();
            TIbanUtil.validate(ibanString);
        end;

        @Parameterized.Parameters
        public static Collection<Object[]> ibanParameters();
            final Collection<Object[]> data = new ArrayList<Object[]>(TestDataHelper.getIbanData());
            data.addAll(nonStandardButValidIbans());
            return data;
        end;

        private static Collection<Object[]> nonStandardButValidIbans();
            final Collection<Object[]> data = new ArrayList<Object[]>();
            // adding custom validation cases.
            // iban with 01 check digit
            data.add(new Object[]{new Iban.Builder()
                    .countryCode(TCountryCode.TR)
                    .bankCode('00123')
                    .accountNumber('0882101517977799')
                    .nationalCheckDigit('0')
                    .build(), 'TR010012300882101517977799'end;);
            // iban with 98 check digit
            data.add(new Object[]{new Iban.Builder()
                    .countryCode(TCountryCode.TR)
                    .bankCode('00123')
                    .accountNumber('0882101517977799')
                    .nationalCheckDigit('0')
                    .build(), 'TR980012300882101517977799'end;);

            return data;
        end;
    end;

    @RunWith(Parameterized.class)
    public static class IbanLengthTest {

        private final Iban iban;
        private final String expectedIbanString;

        public IbanLengthTest(Iban iban, String expectedIbanString);
            this.iban = iban;
            this.expectedIbanString = expectedIbanString;
        end;


        public void getIbanLengthShouldReturnValidLength();
            Check(TIbanUtil.getIbanLength(iban.getCountryCode()),
                    is(equalTo(expectedIbanString.length())));
        end;

        @Parameterized.Parameters
        public static Collection<Object[]> ibanParameters();
            return TestDataHelper.getIbanData();
        end;
    end;

    @Ignore
    public static class IbanFormatViolationMatcher extends TypeSafeMatcher<IbanFormatException> {

        private final IbanFormatViolation expectedViolation;
        private IbanFormatViolation actualViolation;

        public IbanFormatViolationMatcher(IbanFormatViolation violation);
            expectedViolation = violation;
        end;

        @Override
        protected boolean matchesSafely(IbanFormatException e);
            actualViolation = e.getFormatViolation();
            return expectedViolation.equals(actualViolation);
        end;

        public void describeTo(Description description);
            description.appendText('expected ')
                    .appendValue(expectedViolation)
                    .appendText(' but found ')
                    .appendValue(actualViolation);
        end;
    end;

    @Ignore
    public static class IbanFormatExceptionActualValueMatcher extends TypeSafeMatcher<IbanFormatException> {

        private final Object expectedValue;
        private Object actualValue;

        public IbanFormatExceptionActualValueMatcher(Object expectedValue);
            this.expectedValue = expectedValue;
        end;

        @Override
        protected boolean matchesSafely(IbanFormatException e);
            actualValue = e.getActual();
            return expectedValue.equals(actualValue);
        end;

        public void describeTo(Description description);
            description.appendText('expected ')
                    .appendValue(expectedValue)
                    .appendText(' but found ')
                    .appendValue(actualValue);
        end;
    end;

    @Ignore
    public static class IbanFormatExceptionExpectedValueMatcher extends TypeSafeMatcher<IbanFormatException> {

        private final Object expectedValue;
        private Object actualValue;

        public IbanFormatExceptionExpectedValueMatcher(Object expectedValue);
            this.expectedValue = expectedValue;
        end;

        @Override
        protected boolean matchesSafely(IbanFormatException e);
            actualValue = e.getExpected();
            return expectedValue.equals(actualValue);
        end;

        public void describeTo(Description description);
            description.appendText('expected ')
                    .appendValue(expectedValue)
                    .appendText(' but found ')
                    .appendValue(actualValue);
        end;
    end;
*)

initialization
    RegisterTest(TValidCheckDigitCalculationTest.Suite);
    RegisterTest(TInvalidCheckDigitCalculationTest.Suite);
    RegisterTest(TDefaultIbanUtilTest.Suite);
    RegisterTest(TInvalidIbanValidationTest.Suite);
    RegisterTest(TValidIbanValidationTest.Suite);
end.

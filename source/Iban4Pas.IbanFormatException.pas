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
unit Iban4Pas.IbanFormatException;

interface

uses
    System.SysUtils,
    Iban4Pas.BaseTypes,
    Iban4Pas.Exceptions;

type

    TIbanFormatViolation = (
        UNKNOWN,

        IBAN_FORMATTING,
        IBAN_NOT_NULL,
        IBAN_NOT_EMPTY,
        IBAN_VALID_CHARACTERS,

        CHECK_DIGIT_ONLY_DIGITS,
        CHECK_DIGIT_TWO_DIGITS,

        COUNTRY_CODE_TWO_LETTERS,
        COUNTRY_CODE_UPPER_CASE_LETTERS,
        COUNTRY_CODE_EXISTS,
        COUNTRY_CODE_NOT_NULL,

        BBAN_LENGTH,
        BBAN_ONLY_DIGITS,
        BBAN_ONLY_UPPER_CASE_LETTERS,
        BBAN_ONLY_DIGITS_OR_LETTERS,

        BANK_CODE_NOT_NULL,
        ACCOUNT_NUMBER_NOT_NULL
        );

    {**
     * Thrown to indicate that the application has attempted to convert
     * a string to Iban, but that the string does not
     * have the appropriate format.
     *}
    EIbanFormatException = class(EIban4PasException)
    private
        FFormatViolation: TIbanFormatViolation;
        FExpected: string;
        FActual: string;
        FBbanEntryType: TBbanEntryType;
        FInvalidCharacter: Char;
    public
        constructor Create(const s: string); overload;
        constructor Create(const violation: TIbanFormatViolation; const actual, expected, s: string); overload;
        constructor Create(const s: string; const E: Exception); overload;
        constructor Create(const violation: TIbanFormatViolation; const s: string); overload;
        constructor Create(const violation: TIbanFormatViolation; const actual, s: string); overload;
        constructor Create(const violation: TIbanFormatViolation; const entryType: TBbanEntryType; const actual,
          expected, s: string); overload;
        function getActual: string;
        function getBbanEntryType: TBbanEntryType;
        function getExpected: string;
        function getFormatViolation: TIbanFormatViolation;
        function getInvalidCharacter: Char;
    end;

implementation

{**
 * Constructs a <code>IbanFormatException</code> with the
 * specified detail message.
 *
 * @param s the detail message.
 *}
constructor EIbanFormatException.Create(const s: string);
begin
    inherited Create(s);
end;

{**
 * Constructs a <code>IbanFormatException</code> with the
 * specified detail message and cause.
 *
 * @param s the detail message.
 * @param t the cause.
 *}
constructor EIbanFormatException.Create(const s: string; const E: Exception);
begin
    inherited Create(s, E);
end;


{**
 * Constructs a <code>IbanFormatException</code> with the
 * specified violation, actual value, expected value and detail message.
 *
 * @param violation the violation.
 * @param actual the actual value.
 * @param expected the expected value.
 * @param s the detail message.
 *}
constructor EIbanFormatException.Create(const violation: TIbanFormatViolation;
                           const actual: string;
                           const expected: string;
                           const s: string);
begin
    Create(violation, TBbanEntryType.unknown, actual, expected, s);
end;

{**
 * Constructs a <code>IbanFormatException</code> with the
 * specified violation, actual value and detail message.
 *
 * @param violation the violation.
 * @param actual the actual value.
 * @param s the detail message.
 *}
constructor EIbanFormatException.Create(const violation: TIbanFormatViolation;
                           const actual: string;
                           const s: string);
begin
    Create(violation, actual, '', s);
end;

{**
 * Constructs a <code>IbanFormatException</code> with the
 * specified violation, entryType, actual value,
 * invalidCharacter and detail message.
 *
 * @param violation the violation.
 * @param entryType the bban entry type.
 * @param actual the actual value.
 * @param invalidCharacter the invalid character.
 * @param s the detail message.
 *}
constructor EIbanFormatException.Create(const violation: TIbanFormatViolation;
                           const entryType: TBbanEntryType;
                           const actual: string;
                           const expected: string;
                           const s: string);
begin
    inherited Create(s);
    FBbanEntryType := entryType;
    FExpected := expected;
    FActual := actual;
    FFormatViolation := violation;
end;

{**
 * Constructs a <code>IbanFormatException</code> with the
 * specified violation and detail message.
 *
 * @param violation the violation.
 * @param s the detail message.
 *}
constructor EIbanFormatException.Create(const violation: TIbanFormatViolation;
                           const s: string);
begin
    Create(violation, '', '', s);
end;

function EIbanFormatException.getFormatViolation(): TIbanFormatViolation;
begin
    Result := FFormatViolation;
end;

function EIbanFormatException.getExpected(): string;
begin
    Result := FExpected;
end;

function EIbanFormatException.getActual(): string;
begin
    Result := FActual;
end;

function EIbanFormatException.getInvalidCharacter(): Char;
begin
    Result := FInvalidCharacter;
end;

function EIbanFormatException.getBbanEntryType(): TBbanEntryType;
begin
    Result := FBbanEntryType;
end;


end.
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
unit Iban4Pas.BicFormatException;

interface

uses
    System.SysUtils,
    Iban4Pas.Exceptions;

type

    TBicFormatViolation = (
        UNKNOWN,

        BIC_NOT_NULL,
        BIC_NOT_EMPTY,
        BIC_LENGTH_8_OR_11,
        BIC_ONLY_UPPER_CASE_LETTERS,

        BRANCH_CODE_ONLY_LETTERS_OR_DIGITS,
        LOCATION_CODE_ONLY_LETTERS_OR_DIGITS,
        BANK_CODE_ONLY_LETTERS,
        COUNTRY_CODE_ONLY_UPPER_CASE_LETTERS
    );

    {**
     * Thrown to indicate that the application has attempted to convert
     * a string to Bic or to validate Bic's string representation, but the string does not
     * have the appropriate format.
     *}
    EBicFormatException = class(EIban4PasException)
    private
        FFormatViolation: TBicFormatViolation;
        FExpected: string;
        FActual: string;
    public
        constructor Create(const s: string); overload;
        constructor Create(const violation: TBicFormatViolation; const actual, expected, s: string); overload;
        constructor Create(const s: string; const E: Exception); overload;
        constructor Create(const violation: TBicFormatViolation; const s: string); overload;
        constructor Create(const violation: TBicFormatViolation; const actual, s: string); overload;
        function getActual: string;
        function getExpected: string;
        function getFormatViolation: TBicFormatViolation;
    end;

implementation


{**
 * Constructs a <code>BicFormatException</code> with the
 * specified detail message.
 *
 * @param s the detail message.
 *}
constructor EBicFormatException.Create(const s: string);
begin
    inherited Create(s);
end;


{**
 * Constructs a <code>BicFormatException</code> with the
 * specified detail message and cause.
 *
 * @param s the detail message.
 * @param t the cause.
 *}
constructor EBicFormatException.Create(const s: string; const E: Exception);
begin
    inherited Create(s, E);
end;

{**
 * Constructs a <code>BicFormatException</code> with the
 * specified violation, actual value, expected value and detail message.
 *
 * @param violation the violation.
 * @param actual the actual value.
 * @param expected the expected value.
 * @param s the detail message.
 *}
constructor EBicFormatException.Create(const violation: TBicFormatViolation;
                           const actual: string;
                           const expected: string;
                           const s: string);
begin
    inherited Create(s);
    FExpected := expected;
    FActual := actual;
    FFormatViolation := violation;
end;

{**
 * Constructs a <code>BicFormatException</code> with the
 * specified violation and detail message.
 *
 * @param violation the violation.
 * @param s the detail message.
 *}
constructor EBicFormatException.Create(const violation: TBicFormatViolation;
                           const s: string);
begin
    Create(violation, '', '', s);
end;

{**
 * Constructs a <code>BicFormatException</code> with the
 * specified violation, actual value and detail message.
 *
 * @param violation the violation.
 * @param actual the actual value.
 * @param s the detail message.
 *}
constructor EBicFormatException.Create(const violation: TBicFormatViolation;
                           const actual: string;
                           const s: string);
begin
    Create(violation, actual, '', s);
end;

function EBicFormatException.getFormatViolation(): TBicFormatViolation;
begin
    Result := FFormatViolation;
end;

function EBicFormatException.getExpected(): string;
begin
    Result := FExpected;
end;

function EBicFormatException.getActual(): string;
begin
    Result := FActual;
end;


end.
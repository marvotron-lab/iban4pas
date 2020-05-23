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
unit Iban4Pas.InvalidCheckDigitException;

interface

uses
    System.SysUtils,
    Iban4Pas.Exceptions;

type
    {**
     * Thrown to indicate that Iban's check digit is invalid
     *}
    EInvalidCheckDigitException = class(EIban4PasException)
    private
        FActual: string;
        FExpected: string;
    public
        constructor Create(const actual: string; const expected: string; const s: string); overload;
        constructor Create(const s: string; E: Exception); overload;
        function getActual: string;
        function getExpected: string;
    end;

implementation

{**
 * Constructs a <code>InvalidCheckDigitException</code> with the
 * specified actual, expected and detail message.
 *
 * @param actual the actual check digit.
 * @param expected the expected check digit.
 * @param s the detail message.
 *}
constructor EInvalidCheckDigitException.Create(const actual: string; const expected: string; const s: string);
begin
    inherited Create(s);
    FActual := actual;
    FExpected := expected;
end;

{**
 * Constructs a <code>InvalidCheckDigitException</code> with the
 * specified detail message and cause.
 *
 * @param s the detail message.
 * @param t the cause.
 *}
constructor EInvalidCheckDigitException.Create(const s: string; E: Exception);
begin
    inherited Create(s, E);
end;

function EInvalidCheckDigitException.getActual(): string;
begin
    Result := FActual;
end;

function EInvalidCheckDigitException.getExpected(): string;
begin
    Result := FExpected;
end;

end.

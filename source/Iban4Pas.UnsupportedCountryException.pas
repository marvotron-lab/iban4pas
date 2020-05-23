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
unit Iban4Pas.UnsupportedCountryException;

interface

uses
    Iban4Pas.Exceptions;

type
    {**
     * Thrown to indicate that requested country is not supported.
     *}
    EUnsupportedCountryException = class(EIban4PasException)
    private
        FCountryCode: string;
    public
        constructor Create(const s: string); overload;
        constructor Create(countryCode: string; const s: string); overload;
        function getCountryCode: string;
    end;

implementation

{**
 * Constructs a <code>UnsupportedCountryException</code> with the
 * specified detail message.
 *
 * @param s the detail message.
 *}
constructor EUnsupportedCountryException.Create(const s: string);
begin
    inherited Create(s);
end;

{**
 * Constructs a <code>UnsupportedCountryException</code> with the
 * specified country code and detail message.
 *
 * @param countryCode the country code.
 * @param s the detail message.
 *}
constructor EUnsupportedCountryException.Create(countryCode: string; const s: string);
begin
    inherited Create(s);
    FCountryCode := countryCode;
end;

function EUnsupportedCountryException.getCountryCode(): string;
begin
    Result := FCountryCode;
end;
end.
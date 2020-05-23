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
unit Iban4Pas.Exceptions;

{**
 * Base Runtime Exception Class for the library exceptions.
 * @see EIbanFormatException
 * @see EInvalidCheckDigitException
 * @see EUnsupportedCountryException
 * @see EBicFormatException
 *}


interface

uses
    System.SysUtils;

type
    EIban4PasException = class abstract(Exception)
    public
        constructor Create(const msg: string; const E: Exception); overload;
    end;

implementation


constructor EIban4PasException.Create(const msg: string; const E: Exception);
begin
    inherited Create(msg + #13#10 + E.Message)
end;


end.

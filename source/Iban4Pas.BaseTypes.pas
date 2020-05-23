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
unit Iban4Pas.BaseTypes;

{
    The types of following original files can be found in this unit:
    * BbanEntryType.java
    * IbanFormat.java

}

interface

uses
    Iban4Pas.Exceptions,
    //Iban4Pas.IbanFormatException,     //circular ref. problems
    Iban4Pas.InvalidCheckDigitException,
    Iban4Pas.UnsupportedCountryException,
    Iban4Pas.BicFormatException;

type
    EIban4PasException = Iban4Pas.Exceptions.EIban4PasException;
    //EIbanFormatException = Iban4Pas.IbanFormatException.EIbanFormatException;
    EInvalidCheckDigitException = Iban4Pas.InvalidCheckDigitException.EInvalidCheckDigitException;
    EUnsupportedCountryException = Iban4Pas.UnsupportedCountryException.EUnsupportedCountryException;
    EBicFormatException = Iban4Pas.BicFormatException.EBicFormatException;


    {**
     * Iban Format Enum
     *}
    {$SCOPEDENUMS ON}
    TIbanFormat = (
        {**
         * Default Iban Format.
         * Groups of four characters separated by a single space.
         *}
        Default,

        {**
         * No Format.
         *}
        None
    );
    {$SCOPEDENUMS OFF}

    {**
     * Basic Bank Account Number Entry Types.
     *}
    {$SCOPEDENUMS ON}
    TBbanEntryType = (
            unknown,
            bank_code,
            branch_code,
            account_number,
            national_check_digit,
            account_type,
            owner_account_number,
            identification_number
    );
    {$SCOPEDENUMS OFF}

implementation

end.
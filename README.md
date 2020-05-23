iban4pas
========


[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://raw.githubusercontent.com/arturmkrtchyan/iban4j/master/LICENSE.txt)

Iban4pas is a Delphi port of the [Java library iban4j](https://github.com/arturmkrtchyan/iban4j) to delphi.

The library can be used for generation and validation of the International Bank Account Numbers (<a href="http://en.wikipedia.org/wiki/ISO_13616" target="_blank">IBAN ISO_13616</a>) and Business Identifier Codes (<a href="http://en.wikipedia.org/wiki/ISO_9362" target="_blank">BIC ISO_9362</a>).


### Iban quick examples:

```pascal
//uses Iban4Pas.Iban, Iban4Pas.IbanUtil, Iban4Pas.Bic, Iban4Pas.BicUtil, Iban4Pas.CountryCode;

var
    Iban: IIban;
begin
    // How to generate Iban
    Iban := TIban.Builder()
                .countryCode(TCountryCode.AT)
                .bankCode('19043')
                .accountNumber('00234573201')
                .build();


    // How to create Iban object from String
    Iban := TIban.valueOf('DE89370400440532013000');

    // How to create Iban object from formatted String
    Iban := TIban.valueOf('DE89 3704 0044 0532 0130 00', TIbanFormat.Default);

    // How to generate random Iban
    // This is not supported in the Delphi port until now:
    //Iban := TIban.random(CountryCode.AT);
    //Iban := TIban.random();
    //Iban := TIban.Builder()
    //             .countryCode(CountryCode.AT)
    //             .bankCode("19043")
    //             .buildRandom();

    // How to validate Iban
    try
        TIbanUtil.validate('AT611904300234573201');
        TIbanUtil.validate('DE89 3704 0044 0532 0130 00', TIbanFormat.Default);
        // valid
    except
        // invalid
        on E: EIbanFormatException do
          ShowMessage(E.Message);
        on E: EInvalidCheckDigitException do
          ShowMessage(E.Message);
        on E: EUnsupportedCountryException do
          ShowMessage(E.Message);
    end;
end;
```

### Bic quick examples:

```pascal
var
    Bic: IBic;
begin
    //How to create Bic object from String
    Bic := TBic.valueOf('DEUTDEFF');

    //How to validate Bic
    try
        TBicUtil.validate('DEUTDEFF500');
        // valid
    except
        on E: EBicFormatException do
          //invalid
          ShowMessage(E.Message);
    end;
end;
```

##Installation Instructions
* checkout to an folder `...\iban4pas` on your local drive
* add `...\iban4pas\source` to the search path of your project


## About the Delphi port
In most parts the original code was modified as little as possible, even if this meant that this would result in code that is not "typical" for Delphi. Especially the one-class-one-file-policy of Java has been widely preserved to ease tracking of changes.

### What has been ported 
* Class for BICs (interface IBic)
* Class for IBANs (interface IIban)
* Class for country codes (record TCountryCode)
* Static class IbanUtil (TIbanUtil with class routines)
* Static class BicUtil (TBicUtil with class routines)
* Test functions (DUnit testing)

### What is missing
* Code to generate random IBANs
* Some test code (for parameterized tests)
* benchmarking code

## References
- https://github.com/arturmkrtchyan/iban4j
- http://en.wikipedia.org/wiki/ISO_13616
- http://en.wikipedia.org/wiki/ISO_9362
- https://www.ecb.europa.eu/paym/retpaym/paymint/sepa/shared/pdf/iban_registry.pdf

## License
Copyright 2015 Artur Mkrtchyan.  
Delphi port: Copyright 2020 yonojoy@gmail.com.

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0


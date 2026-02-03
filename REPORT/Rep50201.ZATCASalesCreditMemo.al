report 50201 "ZATCA Sales - Credit Memo"
{
    Caption = 'ZATCA Sales - Credit Memo';
    DefaultRenderingLayout = MardaLayout;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    // RDLCLayout = './60001ZATCASalesCreditMemo.rdl';

    dataset
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';
            column(CompanyAddress1; CompanyInfo.Name)
            {
            }
            column(CompanyAddress2; CompanyInfo.Address)
            {
            }
            column(CompanyAddress3; CompanyInfo."Address 2")
            {
            }
            column(CompanyAddress4; CompanyInfo.City)
            {
            }
            column(CompanyAddress5; CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyCountryRegion.Name)
            {
            }
            column(CompanyAddress7; CompanyInfo."Post Code")
            {
            }
            // column(CompanyHomePage; CompanyInfo."Home Page")
            // {
            // }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; DummyCompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPhoneNo_Lbl; CompanyInfoPhoneNoLbl)
            {
            }
            column(CompanyGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyGiroNo_Lbl; CompanyInfoGiroNoLbl)
            {
            }
            column(CompanyBankName; CompanyBankAccount.Name)
            {
            }
            column(CompanyBankName_Lbl; CompanyInfoBankNameLbl)
            {
            }
            column(CompanyBankBranchNo; CompanyBankAccount."Bank Branch No.")
            {
            }
            column(CompanyBankBranchNo_Lbl; CompanyBankAccount.FieldCaption("Bank Branch No."))
            {
            }
            column(CompanyBankAccountNo; CompanyBankAccount."Bank Account No.")
            {
            }
            column(CompanyBankAccountNo_Lbl; CompanyInfoBankAccNoLbl)
            {
            }
            column(CompanyIBAN; CompanyBankAccount.IBAN)
            {
            }
            column(CompanyIBAN_Lbl; CompanyBankAccount.FieldCaption(IBAN))
            {
            }
            column(CompanySWIFT; CompanyBankAccount."SWIFT Code")
            {
            }
            column(CompanySWIFT_Lbl; CompanyBankAccount.FieldCaption("SWIFT Code"))
            {
            }
            column(CompanyBankAccountCurrency; CompanyBankAccount."Currency Code")
            {
            }
            column(CompanyBankAccountCurrency_Lbl; CompanyBankAccount.FieldCaption("Currency Code"))
            {
            }
            column(CompanyLogoPosition; CompanyLogoPosition)
            {
            }
            column(CompanyRegistrationNumber; CompanyInfo.GetRegistrationNumber)
            {
            }
            column(CompanyRegistrationNumber_Lbl; CompanyInfo.GetRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            // column(CompanyLegalOffice; CompanyInfo.GetLegalOffice)
            // {
            // }
            // column(CompanyLegalOffice_Lbl; CompanyInfo.GetLegalOfficeLbl)
            // {
            // }
            // column(CompanyCustomGiro; CompanyInfo.GetCustomGiro)
            // {
            // }
            // column(CompanyCustomGiro_Lbl; CompanyInfo.GetCustomGiroLbl)
            // {
            // }
            column(CompanyLegalStatement; GetLegalStatement)
            {
            }
            column(CustomerAddress1; CustomerInfo.Name)
            {
            }
            column(CustomerAddress2; CustomerInfo.Address)
            {
            }
            column(CustomerAddress3; CustomerInfo."Address 2")
            {
            }
            column(CustomerAddress4; CustAddr[4])
            {
            }
            column(CustomerAddress5; CustomerInfo.City)
            {
            }
            column(CustomerAddress6; CustomerCountryRegion.Name)
            {
            }
            column(CustomerAddress7; CustomerInfo."Post Code")
            {
            }
            column(CustomerAddress8; CustAddr[8])
            {
            }
            column(SellToContactPhoneNoLbl; SellToContactPhoneNoLbl)
            {
            }
            column(SellToContactMobilePhoneNoLbl; SellToContactMobilePhoneNoLbl)
            {
            }
            column(SellToContactEmailLbl; SellToContactEmailLbl)
            {
            }
            column(BillToContactPhoneNoLbl; BillToContactPhoneNoLbl)
            {
            }
            column(BillToContactMobilePhoneNoLbl; BillToContactMobilePhoneNoLbl)
            {
            }
            column(BillToContactEmailLbl; BillToContactEmailLbl)
            {
            }
            column(SellToContactPhoneNo; SellToContact."Phone No.")
            {
            }
            column(SellToContactMobilePhoneNo; SellToContact."Mobile Phone No.")
            {
            }
            column(SellToContactEmail; SellToContact."E-Mail")
            {
            }
            column(BillToContactPhoneNo; BillToContact."Phone No.")
            {
            }
            column(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.")
            {
            }
            column(BillToContactEmail; BillToContact."E-Mail")
            {
            }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
            {
            }
            column(YourReference; "Your Reference")
            {
            }
            column(YourReference_Lbl; FieldCaption("Your Reference"))
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(ExternalDocumentNoLbl; FieldCaption("External Document No."))
            {
            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(ShipmentMethodDescription_Lbl; ShptMethodDescLbl)
            {
            }
            column(ShipmentDate; Format("Shipment Date", 0, 4))
            {
            }
            column(ShipmentDate_Lbl; FieldCaption("Shipment Date"))
            {
            }
            column(Shipment_Lbl; ShipmentLbl)
            {
            }
            column(ShowShippingAddress; ShowShippingAddr)
            {
            }
            column(ShipToAddress_Lbl; ShiptoAddrLbl)
            {
            }
            column(ShipToAddress1; ShipToAddr[1])
            {
            }
            column(ShipToAddress2; ShipToAddr[2])
            {
            }
            column(ShipToAddress3; ShipToAddr[3])
            {
            }
            column(ShipToAddress4; ShipToAddr[4])
            {
            }
            column(ShipToAddress5; ShipToAddr[5])
            {
            }
            column(ShipToAddress6; ShipToAddr[6])
            {
            }
            column(ShipToAddress7; ShipToAddr[7])
            {
            }
            column(ShipToAddress8; ShipToAddr[8])
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentTermsDescription_Lbl; PaymentTermsDescLbl)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(PaymentMethodDescription_Lbl; PaymentMethodDescLbl)
            {
            }
            column(DocumentCopyText; StrSubstNo(DocumentCaption, CopyText))
            {
            }
            column(BilltoCustumerNo; "Bill-to Customer No.")
            {
            }
            column(BilltoCustumerNo_Lbl; FieldCaption("Bill-to Customer No."))
            {
            }
            column(DocumentDate; Format("Document Date", 0, 4))
            {
            }
            column(DocumentDate_Lbl; FieldCaption("Document Date"))
            {
            }
            column(DueDate; Format("Due Date", 0, 4))
            {
            }
            column(DueDate_Lbl; FieldCaption("Due Date"))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentNo_Lbl; InvNoLbl)
            {
            }
            column(AppliesToDocument; AppliesToText)
            {
            }
            column(AppliesToDocument_Lbl; AppliesToTextLbl)
            {
            }
            column(PricesIncludingVAT; "Prices Including VAT")
            {
            }
            column(PricesIncludingVAT_Lbl; FieldCaption("Prices Including VAT"))
            {
            }
            column(PricesIncludingVATYesNo; Format("Prices Including VAT"))
            {
            }
            column(SalesPerson_Lbl; SalespersonLbl)
            {
            }
            column(SalesPersonBlank_Lbl; SalesPersonText)
            {
            }
            column(SalesPersonName; SalespersonPurchaser.Name)
            {
            }
            column(Salesperson_Code; "Salesperson Code") { }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerNo_Lbl; FieldCaption("Sell-to Customer No."))
            {
            }
            column(VATRegistrationNo; GetCustomerVATRegistrationNumber)
            {
            }
            column(VATRegistrationNo_Lbl; GetCustomerVATRegistrationNumberLbl)
            {
            }
            // column(GlobalLocationNumber; GetCustomerGlobalLocationNumber)
            // {
            // }
            // column(GlobalLocationNumber_Lbl; GetCustomerGlobalLocationNumberLbl)
            // {
            // }
            column(LegalEntityType; Cust.GetLegalEntityType)
            {
            }
            column(LegalEntityType_Lbl; Cust.GetLegalEntityTypeLbl)
            {
            }
            column(Copy_Lbl; CopyLbl)
            {
            }
            column(EMail_Header_Lbl; EMailLbl)
            {
            }
            column(HomePage_Header_Lbl; HomePageLbl)
            {
            }
            column(InvoiceDiscountBaseAmount_Lbl; InvDiscBaseAmtLbl)
            {
            }
            column(InvoiceDiscountAmount_Lbl; InvDiscountAmtLbl)
            {
            }
            column(LineAmountAfterInvoiceDiscount_Lbl; LineAmtAfterInvDiscLbl)
            {
            }
            column(LocalCurrency_Lbl; LocalCurrencyLbl)
            {
            }
            column(ExchangeRateASText; ExchangeRateText)
            {
            }
            column(Page_Lbl; PageLbl)
            {
            }
            column(SalesInvoiceLineDiscount_Lbl; SalesInvLineDiscLbl)
            {
            }
            column(DocumentTitle_Lbl; SalesCreditMemoLbl)
            {
            }
            column(ShowWorkDescription; ShowWorkDescription)
            {
            }
            column(Subtotal_Lbl; SubtotalLbl)
            {
            }
            column(Total_Lbl; TotalLbl)
            {
            }
            column(VATAmount_Lbl; VATAmtLbl)
            {
            }
            column(VATBase_Lbl; VATBaseLbl)
            {
            }
            column(VATAmountSpecification_Lbl; VATAmtSpecificationLbl)
            {
            }
            column(VATClauses_Lbl; VATClausesLbl)
            {
            }
            column(VATIdentifier_Lbl; VATIdentifierLbl)
            {
            }
            column(VATPercentage_Lbl; VATPercentageLbl)
            {
            }
            column(VATClause_Lbl; VATClause.TableCaption)
            {
            }
            column(QRCode; QRCode)
            {

            }
            column(CurrencyCode; "Currency Code")
            {


            }
            column(AmountInWords; AmountInWords)
            {

            }
            column(NetInvoice; Format(NetInvoice, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
            {

            }
            column("ZatCrNo"; "Zat Cr No.") { }
            column("BLMAWB"; "B/L-MAWB#") { }
            column("ZATBayanNo"; "ZAT Bayan No.") { }
            column("ZatcaConsignee"; "Zatca Consignee") { }
            column("ZatcaETD"; "Zatca ETD") { }
            column("ZatcaCNTE"; "Zatca CNTE.#") { }
            column("PortL"; "Port L.") { }
            column("PortD"; "Port D.") { }
            column("ZatcaShippper"; "Zatca Shippper") { }
            column(Commodity; Commodity) { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(ArTitle; ArTitle) { }
            column(EngTitle; EngTitle) { }
            column(Isb2B; Isb2B) { }

            column(TotalAmountVAT; TotalAmountVAT) { }
            column(TotalInvDiscAmount; TotalInvDiscAmount) { }
            column(TotalRawAmount; TotalRawAmount) { }
            column(TotalAmountInclVAT; TotalAmountInclVAT) { }
            column(TotalRawLineDiscAmount; TotalRawLineDiscAmount) { }
            column(PaymentMethodEngAr; PaymentMethodEngAr) { }
            column(ForeignUnitPrice; ForeignUnitPrice) { }
            column(ConcatenatedCustomerInfoLine; ConcatenatedCustomerInfoLine) { }
            column(EncodedQrCode; EncodedQrCode) { }
            dataitem(Line; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(LineNo_Line; "Line No.")
                {
                }
                column(AmountExcludingVAT_Line; Amount)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(AmountExcludingVAT_Line_Lbl; FieldCaption(Amount))
                {
                }
                column(AmountIncludingVAT_Line; "Amount Including VAT")
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(AmountIncludingVAT_Line_Lbl; FieldCaption("Amount Including VAT"))
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(Description_Line; Description)
                {
                }
                column(Description_Line_Lbl; FieldCaption(Description))
                {
                }
                column(LineDiscountPercent_Line; "Line Discount %")
                {
                }
                column(LineDiscountPercentText_Line; LineDiscountPctText)
                {
                }
                column(LineAmount_Line; FormattedLineAmount)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(LineAmount_Line_Lbl; FieldCaption("Line Amount"))
                {
                }
                column(ItemNo_Line; "No.")
                {
                }
                column(ItemNo_Line_Lbl; FieldCaption("No."))
                {
                }
                column(ItemReferenceNo_Line; "Item Reference No.")
                {
                }
                column(ItemReferenceNo_Line_Lbl; FieldCaption("Item Reference No."))
                {
                }
                column(ShipmentDate_Line; Format("Shipment Date"))
                {
                }
                column(ShipmentDate_Line_Lbl; PostedShipmentDateLbl)
                {
                }
                column(Quantity_Line; FormattedQuantity)
                {
                }
                column(Quantity_Line_Lbl; FieldCaption(Quantity))
                {
                }
                column(Type_Line; Format(Type))
                {
                }
                column(UnitPrice; FormattedUnitPrice)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(UnitPrice_Lbl; FieldCaption("Unit Price"))
                {
                }
                column(UnitOfMeasure; "Unit of Measure")
                {
                }
                column(UnitOfMeasure_Lbl; FieldCaption("Unit of Measure"))
                {
                }
                column(VATIdentifier_Line; "VAT Identifier")
                {
                }
                column(VATIdentifier_Line_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(VATPct_Line; FormattedVATPct)
                {
                }
                column(VATPct_Line_Lbl; FieldCaption("VAT %"))
                {
                }
                column(TransHeaderAmount; TransHeaderAmount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(RawLineAmount; RawLineAmount) { }
                column(RawUnitPrice; RawUnitPrice) { }
                column(ForeignLineAmountExclVat; ForeignLineAmountExclVat) { }
                column(TotalAmountExclVat; TotalAmountExclVat) { }
                dataitem(ShipmentLine; "Sales Shipment Buffer")
                {
                    DataItemTableView = SORTING("Document No.", "Line No.", "Entry No.");
                    UseTemporary = true;
                    column(DocumentNo_ShipmentLine; "Document No.")
                    {
                    }
                    column(PostingDate_ShipmentLine; "Posting Date")
                    {
                    }
                    column(PostingDate_ShipmentLine_Lbl; FieldCaption("Posting Date"))
                    {
                    }
                    column(Quantity_ShipmentLine; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(Quantity_ShipmentLine_Lbl; FieldCaption(Quantity))
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SetRange("Line No.", Line."Line No.");
                    end;
                }
                dataitem(AssemblyLine; "Posted Assembly Line")
                {
                    DataItemTableView = SORTING("Document No.", "Line No.");
                    UseTemporary = true;
                    column(LineNo_AssemblyLine; "No.")
                    {
                    }
                    column(Description_AssemblyLine; Description)
                    {
                    }
                    column(Quantity_AssemblyLine; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(UnitOfMeasure_AssemblyLine; GetUOMText("Unit of Measure Code"))
                    {
                    }
                    column(VariantCode_AssemblyLine; "Variant Code")
                    {
                    }

                    trigger OnPreDataItem()
                    var
                        ValueEntry: Record "Value Entry";
                    begin
                        Clear(AssemblyLine);
                        if not DisplayAssemblyInformation then
                            CurrReport.Break();
                        GetAssemblyLinesForDocument(
                          AssemblyLine, ValueEntry."Document Type"::"Sales Credit Memo", Line."Document No.", Line."Line No.");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    L_Currency: Record Currency;
                    RoundingPrecision: Decimal;
                    RepCheck: Report Check;
                    CUQrCodeGeneratore: Codeunit "QR Code Generator1";
                    ToRecordId: RecordId;
                    CurrencyExchangeRate: Record "Currency Exchange Rate";
                begin
                    InitializeSalesShipmentLine;
                    ToRecordId := Header.RecordId;
                    
                    // ?? why qrcode as a field is not accessible but it is in zatcasales invoice????
                    // Header.QRCode := CUQrCodeGeneratore.GenerateQRCode(ToRecordId);

                    EncodedQrCode := CUQrCodeGeneratore.GenerateQRCode(ToRecordId);

                    // ZatcaEventMgt.SetQrCode(ToRecordId);
                    // if Type = Type::"G/L Account" then
                    //     "No." := '';

                    if "Line Discount %" = 0 then
                        LineDiscountPctText := ''
                    else
                        LineDiscountPctText := StrSubstNo('%1%', -Round("Line Discount %", 0.1));

                    //Start YANA Added AdvancePayment Calculation
                    if NOT L_Currency.get(Header."Currency Code") then
                        RoundingPrecision := 0.01
                    else
                        RoundingPrecision := L_Currency."Amount Rounding Precision";
                    //End YANA Added AdvancePayment Calculation

                    VATAmountLine.Init();
                    VATAmountLine."VAT Identifier" := "VAT Identifier";
                    VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                    VATAmountLine."Tax Group Code" := "Tax Group Code";
                    VATAmountLine."VAT %" := "VAT %";
                    VATAmountLine."VAT Base" := Amount;
                    VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                    VATAmountLine."Line Amount" := "Line Amount";
                    if "Allow Invoice Disc." then
                        VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                    VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                    VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                    VATAmountLine.InsertLine();

                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := "Line Amount";
                    TotalSubTotal += "Line Amount";
                    TotalInvDiscAmount -= "Inv. Discount Amount";
                    TotalInvDiscAmount -= "Line Discount Amount";
                    TotalAmount += Amount;
                    TotalAmountVAT += "Amount Including VAT" - Amount;
                    TotalAmountInclVAT += "Amount Including VAT";
                    TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");


                    //Start YANA Amount in words
                    RepCheck.InitTextVariable;

                    RepCheck.FormatNoText(NoText, TotalAmountInclVAT, Header."Currency Code");

                    AmountInWords := NoText[1];
                    //End YANA Amount in words

                    FormatDocument.SetSalesCrMemoLine(Line, FormattedQuantity, FormattedUnitPrice, FormattedVATPct, FormattedLineAmount);

                    if FirstLineHasBeenOutput then
                        Clear(DummyCompanyInfo.Picture);
                    FirstLineHasBeenOutput := true;

                    clear(L_Currency);

                    if L_Currency.Get(Header."Foreign Currency Code") then
                        ForeignUnitPrice := Format(Round(CurrencyExchangeRate.ExchangeAmtLCYToFCY(Header."Posting Date", L_Currency.Code, Line."Unit Price", CurrencyExchangeRate.ExchangeRate(Header."Posting Date", L_Currency.Code)), GLSetup."Amount Rounding Precision")) + ' ' + L_Currency.Code;

                    if Header."Prices Including VAT" then begin
                        RawLineAmount := (line."Line Amount" + Line."Line Discount Amount") / (1 + (Line."VAT %" / 100));
                        TotalRawLineDiscAmount += Line."Line Discount Amount" / (1 + (Line."VAT %" / 100))
                    end else begin
                        RawLineAmount := line."Line Amount" + Line."Line Discount Amount";
                        TotalRawLineDiscAmount += Line."Line Discount Amount";
                    end;

                    if Quantity <> 0 then
                        RawUnitPrice := Round(RawLineAmount / Quantity, GLSetup."Amount Rounding Precision");
                    TotalAmountExclVat := RawUnitPrice * Line.Quantity;
                    ForeignLineAmountExclVat := Format(Round(CurrencyExchangeRate.ExchangeAmtLCYToFCY(Header."Posting Date", L_Currency.Code, TotalAmountExclVat, CurrencyExchangeRate.ExchangeRate(Header."Posting Date", L_Currency.Code)), GLSetup."Amount Rounding Precision")) + ' ' + L_Currency.Code;
                    TotalRawAmount += RawLineAmount;
                end;

                trigger OnPreDataItem()
                var
                    CustomerRec: Record Customer;
                    CreditMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    VATAmountLine.DeleteAll();
                    VATClauseLine.DeleteAll();
                    ShipmentLine.Reset();
                    ShipmentLine.DeleteAll();
                    MoreLines := Find('+');
                    while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                        MoreLines := Next(-1) <> 0;
                    if not MoreLines then
                        CurrReport.Break();
                    SetRange("Line No.", 0, "Line No.");
                    TransHeaderAmount := 0;
                    PrevLineAmount := 0;
                    FirstLineHasBeenOutput := false;
                    DummyCompanyInfo.Picture := CompanyInfo.Picture;

                    FirstLineHasBeenOutput := false;
                    CreditMemoHeader.Get(Header."No.");
                    CustomerRec.Get(CreditMemoHeader."Sell-to Customer No.");
                    if CustomerRec."Is B2C" then begin
                        ArTitle := 'اشعار دائن مبسط';
                        EngTitle := 'Simple Credit Memo';
                    end else begin
                        ArTitle := 'اشعار دائن';
                        EngTitle := 'Credit Memo';
                        Isb2B := true;
                    end;
                end;
            }
            dataitem(WorkDescriptionLines; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 99999));
                column(WorkDescriptionLineNumber; Number)
                {
                }
                column(WorkDescriptionLine; WorkDescriptionLine)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if WorkDescriptionInstream.EOS then
                        CurrReport.Break();
                    WorkDescriptionInstream.ReadText(WorkDescriptionLine);
                end;

                trigger OnPostDataItem()
                begin
                    Clear(WorkDescriptionInstream)
                end;

                trigger OnPreDataItem()
                begin
                    if not ShowWorkDescription then
                        CurrReport.Break();
                    Header."Work Description".CreateInStream(WorkDescriptionInstream, TEXTENCODING::UTF8);
                end;
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = SORTING("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(InvoiceDiscountAmount_VATAmountLine; "Invoice Discount Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountAmount_VATAmountLine_Lbl; FieldCaption("Invoice Discount Amount"))
                {
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine; "Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine_Lbl; FieldCaption("Inv. Disc. Base Amount"))
                {
                }
                column(LineAmount_VatAmountLine; "Line Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(LineAmount_VatAmountLine_Lbl; FieldCaption("Line Amount"))
                {
                }
                column(VATAmount_VatAmountLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmount_VatAmountLine_Lbl; FieldCaption("VAT Amount"))
                {
                }
                column(VATAmountLCY_VATAmountLine; VATAmountLCY)
                {
                }
                column(VATAmountLCY_VATAmountLine_Lbl; VATAmountLCYLbl)
                {
                }
                column(VATBase_VatAmountLine; "VAT Base")
                {
                    AutoFormatExpression = Line.GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(VATBase_VatAmountLine_Lbl; FieldCaption("VAT Base"))
                {
                }
                column(VATBaseLCY_VATAmountLine; VATBaseLCY)
                {
                }
                column(VATBaseLCY_VATAmountLine_Lbl; VATBaseLCYLbl)
                {
                }
                column(VATIdentifier_VatAmountLine; "VAT Identifier")
                {
                }
                column(VATIdentifier_VatAmountLine_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(VATPct_VatAmountLine; "VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VATPct_VatAmountLine_Lbl; FieldCaption("VAT %"))
                {
                }
                column(NoOfVATIdentifiers; Count)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY :=
                      GetBaseLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");
                    VATAmountLCY :=
                      GetAmountLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");

                    TotalVATBaseLCY += VATBaseLCY;
                    TotalVATAmountLCY += VATAmountLCY;

                    if "VAT Clause Code" <> '' then begin
                        VATClauseLine := VATAmountLine;
                        if VATClauseLine.Insert() then;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Clear(VATBaseLCY);
                    Clear(VATAmountLCY);

                    TotalVATBaseLCY := 0;
                    TotalVATAmountLCY := 0;
                end;
            }
            dataitem(VATClauseLine; "VAT Amount Line")
            {
                DataItemTableView = SORTING("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(VATIdentifier_VATClauseLine; "VAT Identifier")
                {
                }
                column(Code_VATClauseLine; VATClause.Code)
                {
                }
                column(Code_VATClauseLine_Lbl; VATClause.FieldCaption(Code))
                {
                }
                column(Description_VATClauseLine; VATClause.Description)
                {
                }
                column(Description2_VATClauseLine; VATClause."Description 2")
                {
                }
                column(VATAmount_VATClauseLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(NoOfVATClauses; Count)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "VAT Clause Code" = '' then
                        CurrReport.Skip();
                    if not VATClause.Get("VAT Clause Code") then
                        CurrReport.Skip();
                    // VATClause.GetDescription(Header);
                end;
            }
            dataitem(ReportTotalsLine; "Report Totals Buffer")
            {
                DataItemTableView = SORTING("Line No.");
                UseTemporary = true;
                column(Description_ReportTotalsLine; Description)
                {
                }
                column(Amount_ReportTotalsLine; Amount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountFormatted_ReportTotalsLine; "Amount Formatted")
                {
                }
                column(FontBold_ReportTotalsLine; "Font Bold")
                {
                }
                column(FontUnderline_ReportTotalsLine; "Font Underline")
                {
                }

                trigger OnPreDataItem()
                begin
                    CreateReportTotalLines;
                end;
            }
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(GreetingText; GreetingLbl)
                {
                }
                column(BodyText; BodyLbl)
                {
                }
                column(ClosingText; ClosingLbl)
                {
                }
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(TotalNetAmount; Format(TotalAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalVATBaseLCY; TotalVATBaseLCY)
                {
                }
                column(TotalAmountIncludingVAT; Format(TotalAmountInclVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalVATAmount; Format(TotalAmountVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalVATAmountLCY; TotalVATAmountLCY)
                {
                }
                column(TotalInvoiceDiscountAmount; Format(TotalInvDiscAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
                {
                }
                column(TotalVATAmountText; VATAmountLine.VATAmountText)
                {
                }
                column(TotalExcludingVATText; TotalExclVATText)
                {
                }
                column(TotalIncludingVATText; TotalInclVATText)
                {
                }
                column(TotalSubTotal; Format(TotalSubTotal, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalSubTotalMinusInvoiceDiscount; Format(TotalSubTotal + TotalInvDiscAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalText; TotalText)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                CurrencyExchangeRate: Record "Currency Exchange Rate";
            begin
                CustomerInfo.Get(Header."Bill-to Customer No.");
                if CustomerInfo."Country/Region Code" <> '' then begin
                    CustomerCountryRegion.Get(CustomerInfo."Country/Region Code");
                end;
                if not IsReportInPreviewMode then
                    CODEUNIT.Run(CODEUNIT::"Sales Cr. Memo-Printed", Header);

                CalcFields("Work Description");
                ShowWorkDescription := "Work Description".HasValue;
                CurrReport.Language := G_Language.GetLanguageIdOrDefault("Language Code");

                FormatAddressFields(Header);
                FormatDocumentFields(Header);
                if SellToContact.Get("Sell-to Contact No.") then;
                if BillToContact.Get("Bill-to Contact No.") then;

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                if not CompanyBankAccount.Get(Header."Company Bank Account Code") then
                    CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);

                if "Currency Code" <> '' then begin
                    CurrencyExchangeRate.FindCurrency("Posting Date", "Currency Code", 1);
                    CalculatedExchRate :=
                      Round(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
                    ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
                end;

                TotalSubTotal := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;
                TotalAmountInclVAT := 0;
                TotalPaymentDiscOnVAT := 0;

                // Filling company addresses and info in one line
                ConcatenatedCustomerInfoLine := Cust."ZATCA Building No." + ' ' + Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust."Post Code" + ' ' + Cust.City + ' ' + Cust."Country/Region Code";

                if PaymentMethod.Code <> '' then
                    if PaymentMethod.Description <> '' then
                        PaymentMethodEngAr := PaymentMethod.Code + ' & ' + PaymentMethod.Description
                    else
                        PaymentMethodEngAr := PaymentMethod.Code;
            end;

            trigger OnPreDataItem()
            var
                CustomerRec: Record Customer;
                CreditMemoHeader: Record "Sales Cr.Memo Header";
            begin
                FirstLineHasBeenOutput := false;
            end;

            trigger OnPostDataItem()
            var
                CustomerRec: Record Customer;
                CreditMemoHeader: Record "Sales Cr.Memo Header";
            begin
                FirstLineHasBeenOutput := false;
                CreditMemoHeader.Get(Header."No.");
                CustomerRec.Get(CreditMemoHeader."Sell-to Customer No.");
                if CustomerRec."Is B2C" then begin
                    ArTitle := 'اشعار دائن مبسط';
                    EngTitle := 'Simple Credit Memo';
                end else begin
                    ArTitle := 'اشعار دائن';
                    EngTitle := 'Credit Memo';
                    Isb2B := true;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                    field(DisplayShipmentInformation; DisplayShipmentInformation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Shipments';
                        ToolTip = 'Specifies that shipments are shown on the document.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            //InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    rendering
    {
        // layout(NovaLayout)
        // {
        //     Type = RDLC;
        //     LayoutFile = 'REPORT\60000ZATCASalesInvoiceNova.rdl';
        //     CaptionML = ENU = 'ZATCA Sales Invoice - Nova', ENZ = 'فاتورة ضريبية';
        // }
        layout(MardaLayout)
        {
            Type = RDLC;
            LayoutFile = 'REPORT\60001ZATCASalesCreditMemoMarda.rdl';
            CaptionML = ENU = 'ZATCA Credit Memo - Marda', ENZ = 'اشعار دائن';
        }
        layout(NovaLayou)
        {
            Type = RDLC;
            LayoutFile = 'REPORT\60001ZATCASalesCreditMemoNova.rdl';
            CaptionML = ENU = 'ZATCA Credit Memo - Nova', ENZ = 'اشعار دائن';
        }
        layout(ShaqraLayout)
        {
            Type = RDLC;
            LayoutFile = 'REPORT\60001ZATCACreditMemoShaqra.rdl';
            CaptionML = ENU = 'ZATCA Credit Memo - Shaqra', ENZ = 'اشعار دائن';
        }

    }
    labels
    {
    }




    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        if CompanyInfo."Country/Region Code" <> '' then begin
            CompanyCountryRegion.Get(CompanyInfo."Country/Region Code");
        end;
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo;
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode then
            if Header.FindSet() then
                repeat
                    if Header."Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          6, Header."No.", 0, 0, DATABASE::Contact, Header."Bill-to Contact No.", Header."Salesperson Code",
                          Header."Campaign No.", Header."Posting Description", '')
                    else
                        SegManagement.LogDocument(
                          6, Header."No.", 0, 0, DATABASE::Customer, Header."Bill-to Customer No.", Header."Salesperson Code",
                          Header."Campaign No.", Header."Posting Description", '');
                until Header.Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if Header.GetFilters = '' then
            Error(NoFilterSetErr);

        // if not CurrReport.UseRequestPage then
        //     InitLogInteraction;

        CompanyLogoPosition := SalesSetup."Logo Position on Documents";
    end;



    // local procedure InitLogInteraction()
    // begin
    //     LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
    // end;

    local procedure InitializeSalesShipmentLine(): Date
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer";
    begin
        if Line."Return Receipt No." <> '' then
            if ReturnReceiptHeader.Get(Line."Return Receipt No.") then
                exit(ReturnReceiptHeader."Posting Date");
        if Header."Return Order No." = '' then
            exit(Header."Posting Date");
        if Line.Type = Line.Type::" " then
            exit(0D);

        ShipmentLine.GetLinesForSalesCreditMemoLine(Line, Header);

        ShipmentLine.Reset();
        ShipmentLine.SetRange("Line No.", Line."Line No.");
        if ShipmentLine.Find('-') then begin
            SalesShipmentBuffer2 := ShipmentLine;
            if not DisplayShipmentInformation then
                if ShipmentLine.Next() = 0 then begin
                    ShipmentLine.Get(
                      SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                    ShipmentLine.Delete();
                    exit(SalesShipmentBuffer2."Posting Date");
                end;
            ShipmentLine.CalcSums(Quantity);
            if ShipmentLine.Quantity <> Line.Quantity then begin
                ShipmentLine.DeleteAll();
                exit(Header."Posting Date");
            end;
        end;
        exit(Header."Posting Date");
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody);
    end;

    local procedure DocumentCaption(): Text[250]
    var
        DocCaption: Text[250];
    begin
        OnBeforeDocumentCaption(Header, DocCaption);
        if DocCaption <> '' then
            exit(DocCaption);

        if Header."Prepayment Credit Memo" then
            exit(SalesPrepCreditMemoNoLbl);
        exit(SalesCreditMemoNoLbl);
    end;

    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[50]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    local procedure CreateReportTotalLines()
    begin
        ReportTotalsLine.DeleteAll();
        if (TotalInvDiscAmount <> 0) or (TotalAmountVAT <> 0) then
            ReportTotalsLine.Add(SubtotalLbl, TotalSubTotal, true, false, false);
        if TotalInvDiscAmount <> 0 then begin
            ReportTotalsLine.Add(InvDiscountAmtLbl, TotalInvDiscAmount, false, false, false);
            if TotalAmountVAT <> 0 then
                ReportTotalsLine.Add(TotalExclVATText, TotalAmount, true, false, false);
        end;
        if TotalAmountVAT <> 0 then
            ReportTotalsLine.Add(VATAmountLine.VATAmountText, TotalAmountVAT, false, true, false);
    end;

    local procedure FormatAddressFields(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatAddr.GetCompanyAddr(SalesCrMemoHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesCrMemoBillTo(CustAddr, SalesCrMemoHeader);
        ShowShippingAddr := FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, SalesCrMemoHeader);
    end;

    local procedure FormatDocumentFields(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatDocument.SetTotalLabels(SalesCrMemoHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesCrMemoHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesCrMemoHeader."Payment Terms Code", SalesCrMemoHeader."Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod, SalesCrMemoHeader."Payment Method Code", SalesCrMemoHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesCrMemoHeader."Shipment Method Code", SalesCrMemoHeader."Language Code");

        AppliesToText :=
          FormatDocument.SetText(SalesCrMemoHeader."Applies-to Doc. No." <> '', StrSubstNo('%1 %2', Format(SalesCrMemoHeader."Applies-to Doc. Type"), SalesCrMemoHeader."Applies-to Doc. No."));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDocumentCaption(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var DocCaption: Text[250])
    begin
    end;



    var
        SalesCreditMemoNoLbl: Label 'Sales - Credit Memo %1';
        SalespersonLbl: Label 'Sales person';
        CompanyInfoBankAccNoLbl: Label 'Account No.';
        CompanyInfoBankNameLbl: Label 'Bank';
        CompanyInfoGiroNoLbl: Label 'Giro No.';
        CompanyInfoPhoneNoLbl: Label 'Phone No.';
        CopyLbl: Label 'Copy';
        EMailLbl: Label 'Email';
        HomePageLbl: Label 'Home Page';
        InvDiscBaseAmtLbl: Label 'Invoice Discount Base Amount';
        InvDiscountAmtLbl: Label 'Invoice Discount';
        InvNoLbl: Label 'Credit Memo No.';
        LineAmtAfterInvDiscLbl: Label 'Payment Discount on VAT';
        LocalCurrencyLbl: Label 'Local Currency';
        PageLbl: Label 'Page';
        PaymentTermsDescLbl: Label 'Payment Terms';
        PaymentMethodDescLbl: Label 'Payment Method';
        PostedShipmentDateLbl: Label 'Shipment Date';
        SalesInvLineDiscLbl: Label 'Discount %';
        SalesCreditMemoLbl: Label 'Credit Memo';
        ShipmentLbl: Label 'Shipment';
        ShiptoAddrLbl: Label 'Ship-to Address';
        ShptMethodDescLbl: Label 'Shipment Method';
        SubtotalLbl: Label 'Subtotal';
        TotalLbl: Label 'Total';
        VATAmtSpecificationLbl: Label 'VAT Amount Specification';
        VATAmtLbl: Label 'VAT Amount';
        VATAmountLCYLbl: Label 'VAT Amount (LCY)';
        VATBaseLbl: Label 'VAT Base';
        VATBaseLCYLbl: Label 'VAT Base (LCY)';
        VATClausesLbl: Label 'VAT Clause';
        VATIdentifierLbl: Label 'VAT Identifier';
        VATPercentageLbl: Label 'VAT %';
        SellToContactPhoneNoLbl: Label 'Sell-to Contact Phone No.';
        SellToContactMobilePhoneNoLbl: Label 'Sell-to Contact Mobile Phone No.';
        SellToContactEmailLbl: Label 'Sell-to Contact E-Mail';
        BillToContactPhoneNoLbl: Label 'Bill-to Contact Phone No.';
        BillToContactMobilePhoneNoLbl: Label 'Bill-to Contact Mobile Phone No.';
        BillToContactEmailLbl: Label 'Bill-to Contact E-Mail';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CompanyBankAccount: Record "Bank Account";
        DummyCompanyInfo: Record "Company Information";
        CompanyInfo: Record "Company Information";
        CompanyCountryRegion: Record "Country/Region";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        CustomerInfo: Record Customer;
        CustomerCountryRegion: Record "Country/Region";
        RespCenter: Record "Responsibility Center";
        VATClause: Record "VAT Clause";
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        G_Language: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        AutoFormat: Codeunit "Auto Format";
        WorkDescriptionInstream: InStream;
        WorkDescriptionLine: Text;
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SalesPersonText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        LineDiscountPctText: Text;
        FormattedVATPct: Text;
        FormattedUnitPrice: Text;
        FormattedQuantity: Text;
        FormattedLineAmount: Text;
        MoreLines: Boolean;
        CopyText: Text[30];
        ShowWorkDescription: Boolean;
        ShowShippingAddr: Boolean;
        LogInteraction: Boolean;
        SalesPrepCreditMemoNoLbl: Label 'Sales - Prepmt. Credit Memo %1';
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TransHeaderAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        DisplayShipmentInformation: Boolean;
        CompanyLogoPosition: Integer;
        FirstLineHasBeenOutput: Boolean;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;
        ExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        PrevLineAmount: Decimal;
        AppliesToText: Text;
        // QRCode: Text;
        AppliesToTextLbl: Label 'Applies to Document';
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidently printing all documents.';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Thank you for your business. Your credit memo is attached to this message.';
        RetentionPercentage: Label 'Retention @ %1 %';
        RetentionPercentage_AR: Label 'حجوزات الضمان @  % %1';
        AdvancePayment_lbl: Label 'Advance Payment Recovering @ %1 %';
        AdvancePayment_AR_lbl: Label 'خصم الدفعة المقدمة @  % %1';
        AdvancePaymentAmount: Decimal;
        AdvancePaymentVATAmount: Decimal;
        NetInvoice: Decimal;
        AmountInWords: Text;
        NoText: array[2] of Text;
        ZatcaEventMgt: Codeunit "ZATCA Event Mgt";
        EngTitle: Text;
        ArTitle: Text;
        Isb2B: Boolean;
        ForeignUnitPrice: Text;
        ConcatenatedCustomerInfoLine: Text;
        RawLineAmount: Decimal;
        RawUnitPrice: Decimal;
        TotalRawAmount: Decimal;
        TotalRawLineDiscAmount: Decimal;
        PaymentMethodEngAr: Text;
        ForeignLineAmountExclVat: Text;
        TotalAmountExclVat: Decimal;
        EncodedQrCode: Text;

}


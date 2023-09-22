/// <summary>
/// PageExtension PosatedSaleInvoiceExt (ID 50102) extends Record Posted Sales Invoices.
/// </summary>
pageextension 50106 "PosatedSaleInvoiceExt" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("Your Reference40569"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
        }
    }
}
#pragma implicitwith disable
pageextension 50117 "SalesQuotesExtn" extends "Sales Quotes"

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
#pragma implicitwith restore

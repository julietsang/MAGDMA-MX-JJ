#pragma implicitwith disable
pageextension 50110 "SalesOrderListExt" extends "Sales Order List"
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

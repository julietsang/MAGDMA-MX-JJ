#pragma implicitwith disable
pageextension 50118 "BlanketSalesOrderExtn" extends "Blanket Sales Orders"

{
    layout
    {
        addafter("No.")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;

            }
        }
    }
}
#pragma implicitwith restore

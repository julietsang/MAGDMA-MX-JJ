#pragma implicitwith disable
pageextension 50112 "SalesCRmemoListExt" extends "Sales Credit Memos"

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

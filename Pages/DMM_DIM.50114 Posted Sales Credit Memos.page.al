#pragma implicitwith disable
pageextension 50114 "PostedSalesCRmemoListExt" extends "Posted Sales Credit Memos"

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

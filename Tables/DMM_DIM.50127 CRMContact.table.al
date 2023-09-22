tableextension 50127 CRMContact extends "CRM Account"
{

    fields
    {
        field(50100; "RFC No."; Text[50])
        {
            Caption = 'dmm_rfc';
            Description = 'Specifies the federal registration number for taxpayers.';
            ExternalName = 'dmm_rfc';
            ExternalType = 'String';


        }
        field(50101; "CFDI Customer Name"; Text[100])
        {
            Caption = 'dmm_cfdicustomername';
            Description = 'Type a RFC No.';
            ExternalName = 'dmm_cfdicustomername';
            ExternalType = 'String';


        }
        field(50102; PaymentMethodCodeEnum; Enum "CDS Payment Method Code")


        {
            Caption = 'dmm_paymentmethod';
            Description = 'Select the payment method to indicate when the customer needs to pay the total amount.';
            ExternalName = 'dmm_paymentmethod';
            ExternalType = 'Picklist';
            InitValue = " ";
        }
        field(50103; PaymentMethodCode; Option)
        {
            Caption = 'dmm_paymentmethod';
            Description = 'Select the payment Method to indicate when the customer needs to pay the total amount.';
            ExternalName = 'dmm_paymentmethod';
            ExternalType = 'Picklist';
            InitValue = " ";
            OptionCaption = ' ,01 Efectivo,02 Cheque nominativo,03 Transferencia electrónica de fondos,04 Tarjeta de crédito,05 Monedero electrónico,08 Vales de despensa,12 Dación en pago,13 Pago por subrogación,14 PAgo por consignación,15 Condonación,17 Compensación,23 Novación,24 Confusión,25 Remisión de deuda,26 Prescripción o caducidad,27 A satisfacción del acreedor,28 Tarjeta de débito,29 Tarjeta de servicios,99 Por definir';

            OptionOrdinalValues = -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20;
            OptionMembers = " ","01","02","03","04","05","06","08","12","13","14","15","17","23","24","25","26","27","28","29","99";
            ObsoleteState = Removed;
            ObsoleteReason = 'This field is replaced by field 203 PaymentMethodCodeEnum.';
            ObsoleteTag = '19.0';
        }
        field(50104; SatusecodeCodeEnum; Enum "CDS SAT Use Code")


        {
            Caption = 'dmm_cfdipurpose';
            Description = 'Select the CFDI Purpose';
            ExternalName = 'dmm_cfdipurpose';
            ExternalType = 'Picklist';
            InitValue = " ";
        }
        field(50105; SatusecodeCode; Option)
        {
            Caption = 'dmm_cfdipurpose';
            Description = 'Select the Method to indicate when the customer needs to pay the total amount.';
            ExternalName = 'dmm_cfdipurpose';
            ExternalType = 'Picklist';
            InitValue = " ";
            OptionCaption = ' ,Honorarios médicos dentales y gastos hospitalarios.,Gastos médicos por incapacidad o discapacidad,Gastos funerales.,Donativos.,Intereses reales efectivamente pagados por créditos hipotecarios (casa habitación).,Aportaciones voluntarias al SAR.,Primas por seguros de gastos médicos,Gastos de transportación escolar obligatoria.,Depósitos en cuentas para el ahorro primas que tengan como base planes de pensiones,Pagos por servicios educativos (colegiaturas),Adquisición de mercancias, Devoluciones descuentos o bonificaciones,Gastos en general,Construcciones, Mobilario y equipo de oficina por inversiones,Equipo de transporte,Equipo de computo y accesorios,Dados troqueles moldes matrices y herramental,Comunicaciones telefónicas,Comunicaciones satelitales,Otra maquinaria y equipo,Por definir';
            OptionOrdinalValues = -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22;
            OptionMembers = " ","D01","D02","D03","D04","D05","D06","D07","D08","D09","D010","G01","G02","G03","I01","I02","I03","I04","I05","I06","I07","I08","P01";
            /* ObsoleteState = Removed;
             ObsoleteReason = 'This field is replaced by field 203 PaymentMethodCodeEnum.';
             ObsoleteTag = '19.0';*/
        }
        field(50106; SataxschemeCodeEnum; Enum "CDS SAT Tax Scheme code")


        {
            Caption = 'dmm_sattaxregimeclassification';
            Description = 'Select the  method to indicate when the customer needs to pay the total amount.';
            ExternalName = 'dmm_sattaxregimeclassification';
            ExternalType = 'Picklist';
            InitValue = " ";
        }
        field(50107; SataxschemeCode; Option)
        {
            Caption = 'dmm_sattaxregimeclassification';
            Description = 'Select the Method to indicate when the customer needs to pay the total amount.';
            ExternalName = 'dmm_sattaxregimeclassification';
            ExternalType = 'Picklist';
            InitValue = " ";
            OptionCaption = ' , General de Ley Personas Morales, Personas Morales con Fines no Lucrativos,Sueldos y Salarios e Ingresos Asimilados a Salarios,Arrendamiento,Régimen de Enajenación o Adquisición de Bienes,Demás ingresosConsolidación,Residentes en el Extranjero sin Establecimiento Permanente en México,Ingresos por Dividendos (socios y accionistas),Personas Físicas con Actividades Empresariales y Profesionales,Ingresos por intereses,Régimen de los ingresos por obtención de premios,Sin obligaciones fiscales,Sociedades Cooperativas de Producción que optan por diferir sus ingresos,Incorporación Fiscal,Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras,Opcional para Grupos de Sociedades,Coordinados,Hidrocarburos,De los Regímenes Fiscales Preferentes y de las Empresas Multinacionales,Enajenación de acciones en bolsa de valores';
            OptionOrdinalValues = -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21;
            OptionMembers = " ","601","603","605","606","607","608","809","610","611","612","614","615","616","620","621","622","623","624","628","629","630";
            ObsoleteState = Removed;
            ObsoleteReason = 'This field is replaced by field 203 PaymentMethodCodeEnum.';
            ObsoleteTag = '19.0';
        }
        field(50108; CFDIExportCodeEnum; Enum "CDS CFDI Export Code")


        {
            Caption = 'dmm_cfdiexportcode';
            Description = 'Select the CFDI exportcode';
            ExternalName = 'dmm_cfdiexportcode';
            ExternalType = 'Picklist';
            InitValue = " ";
        }
        field(50109; CFDIExportCode; Option)
        {
            Caption = 'dmm_cfdiexportcode';
            Description = 'Select the CFDI exportcode.';
            ExternalName = 'dmm_cfdiexportcode';
            ExternalType = 'Picklist';
            InitValue = " ";
            OptionCaption = ' , 01 No aplica, 02 Definitiva,03 Temporal,04 Definitiva con clave distinta a A1 o no existe CFF';
            OptionOrdinalValues = -1, 1, 2, 3, 4;
            OptionMembers = " ","01","02","03","04";
            ObsoleteState = Removed;
            ObsoleteReason = 'This field is replaced by field 203 PaymentMethodCodeEnum.';
            ObsoleteTag = '19.0';
        }
        field(50110; "Customer No."; Text[50])
        {
            Caption = 'accountnumber';
            Description = 'Specifies the federal registration number for taxpayers.';
            ExternalName = 'accountnumber';
            ExternalType = 'String';


        }


    }
}
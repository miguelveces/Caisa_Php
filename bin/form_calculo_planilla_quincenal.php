<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
 set_time_limit (600);
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultReceiptEmployee="";
$resultLegalTaxEmployee="";
$resultDiscountsIncomeEmployee="";
$resultEmployeesRecordsTransactions="";
$resultEmployeeRecordTransaction="";
$resultDiscountsIncomeEmployeeDetail="";
$resultBankAccount="";
$data="";
$estado = 1;
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");

if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data

    //$id_empresa = isset($_POST['numcompany']) ? mysqli_real_escape_string($connect, $_POST['numcompany']) :  "";
	
	$numeroquincena = isset($_POST['numberfortnight']) ? mysqli_real_escape_string($connect, $_POST['numberfortnight']) :  "";
	$diapago = isset($_POST['paymentdate']) ? mysqli_real_escape_string($connect, $_POST['paymentdate']) :  "";
	$decimo = isset($_POST['thirteenth']) ? mysqli_real_escape_string($connect, $_POST['thirteenth']) :  "";
	$id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";
	$id_empresa= isset($_SESSION['id_empresa']) ? mysqli_real_escape_string($connect, $_SESSION['id_empresa']) :  "";

	

	/**************************TODOS LOS EMPLEADO POR EMPRESA***********************************/
    //$id_empleado = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	$param = array('id_empresa' => $id_empresa); 
	$employees = $client->call('GetEmployeeByidCompany',$param,'','','',true);
	
	
	
	
	$param = array(); 
	$period = $client->call('GetPeriodByStatus',$param,'','','',true);
    $id_periodo=$period[0]['id_periodo'];
	$anno_fiscal=$period[0]['anno_fiscal'];
	
	
	
	
	$param = array('id_empresa' => $id_empresa,'id_periodo' =>$id_periodo); 
	$resultReceiptEmployee = $client->call('GetReceiptEmployeeByCompany',$param,'','','',true);
	
	$resultEmployeesRecordsTransactions = $client->call('GetEmployeesRecordsTransactionsByCompany',$param,'','','',true);

    if($resultEmployeesRecordsTransactions[0]['msg']=='False'){distribucionhoras($id_empresa, $id_periodo, $anno_fiscal);}
	
	if($resultReceiptEmployee[0]['msg']=='False'){
	    //$resultReceiptEmployee="";
		
			
		foreach($employees as $employee){
			$rataxhora=$employee['rata_x_hora'];
			$id_empleado=$employee['id_empleado'];
			$numero_empleado = $employee['numero_empleado']; 
			
			$param = array('id_empleado' => $id_empleado);
			$bankaccount = $client->call('GetBankAccountByidEmployee',$param,'','','',true);
			if($bankaccount[0]['id_cuenta_banco_empleado']==null)
			{    
				$param = array('id_empleado' => $id_empleado,'numero_empleado' => $numero_empleado,
				'numero_cuenta' => "0000000000000",'id_tipo_cuenta' => 4,
				'nombre_tipo_cuenta' => "CUENTAS AHORROS",'tipo_tranferencia' => "ACH",'id_banco' => 1); 
				$resultBankAccount = $client->call('AddBankAccount',$param,'','','',true);
			}
			 
			
			
			$viewemployee = $client->call('GetEmployeesByid',$param,'','','',true);
			$discountsincomeemployees = $client->call('GetAllDiscountsIncomeEmployeeByidEmployee',$param,'','','',true);
			
			
			
			//$id_empleado = $viewemployee[0]['id_empleado']; 
			//$numero_empleado = $viewemployee[0]['numero_empleado']; 
			//$id_periodo = $viewemployee[0]['id_periodo']; 
			$id_seccion = $viewemployee[0]['id_seccion']; 
			$nombre_seccion = $viewemployee[0]['nombre_seccion']; 
			$nombre_departamento = $viewemployee[0]['nombre_departamento']; 
			$nombre_empleado = $viewemployee[0]['nombre']; 
			$apellido_empleado = $viewemployee[0]['apellido']; 
			$cedula_empleado = $viewemployee[0]['cedula']; 
			//$id_empresa = $viewemployee[0]['id_empresa']; 
			$nombre_empresa = $viewemployee[0]['nombre_empresa']; 
			//$rataxhora = $viewemployee[0]['rata_x_hora']; 
			$claveir = $viewemployee[0]['clave_renta']; 
			$numero_comprobante = ""; 
			$numero_cuenta = $viewemployee[0]['numero_cuenta']; 
			$id_tipo_cuenta = $viewemployee[0]['id_tipo_cuenta']; 
			$id_banco = $viewemployee[0]['id_banco']; 
			$total_ingreso = ""; 
			$total_descuento = ""; 
			
			
			
			$param = array('id_empleado' => $id_empleado,'id_periodo' =>$id_periodo);
			$employeerecordtransaction= $client->call('GetEmployeesRecordsTransactionsByid',$param,'','','',true);
					$horasregular=$employeerecordtransaction[0]['horas_regular']*$employeerecordtransaction[0]['factor_reg']*$rataxhora;
					$horasdomingo=$employeerecordtransaction[0]['horas_domingo']*$employeerecordtransaction[0]['factor_dom']*$rataxhora;
					$horasferiado=$employeerecordtransaction[0]['horas_feriado']*$employeerecordtransaction[0]['factor_fer']*$rataxhora;
					$horascompensatorio=$employeerecordtransaction[0]['horas_compensatorio']*$employeerecordtransaction[0]['factor_com']*$rataxhora;
					$horasextra1=$employeerecordtransaction[0]['horas_extra1']*$employeerecordtransaction[0]['factor1']*$rataxhora;
					$horasextra2=$employeerecordtransaction[0]['horas_extra2']*$employeerecordtransaction[0]['factor2']*$rataxhora;
					$horasextra3=$employeerecordtransaction[0]['horas_extra3']*$employeerecordtransaction[0]['factor3']*$rataxhora;
					$horasextra4=$employeerecordtransaction[0]['horas_extra4']*$employeerecordtransaction[0]['factor4']*$rataxhora;
					$horasextra5=$employeerecordtransaction[0]['horas_extra5']*$employeerecordtransaction[0]['factor5']*$rataxhora;
					$horasextra6=$employeerecordtransaction[0]['horas_extra6']*$employeerecordtransaction[0]['factor6']*$rataxhora;
					$horasextra7=$employeerecordtransaction[0]['horas_extra7']*$employeerecordtransaction[0]['factor7']*$rataxhora;
					$horasextra8=$employeerecordtransaction[0]['horas_extra8']*$employeerecordtransaction[0]['factor8']*$rataxhora;
					$horasextra9=$employeerecordtransaction[0]['horas_extra9']*$employeerecordtransaction[0]['factor9']*$rataxhora;
					$horasextra10=$employeerecordtransaction[0]['horas_extra10']*$employeerecordtransaction[0]['factor10']*$rataxhora;
				 
				  $total_ingreso=$horasregular+$horasdomingo+$horasferiado+$horascompensatorio+$horasextra1+$horasextra2+$horasextra3+$horasextra4+$horasextra5+$horasextra6+$horasextra7+$horasextra8+$horasextra9+$horasextra10;


		
			$param = array();
			$legaltax = $client->call('GetLegalTaxesByStatus',$param,'','','',true);
			
			$monto_isr="0.00";
			$monto_periodo="0.00";
			$total_monto_periodo="0.00";
			$monto_ss= round(($total_ingreso*$legaltax[0]['segsoc']), 2);
			$monto_se= round(($total_ingreso*$legaltax[0]['segedu']), 2);
			if($total_ingreso > 423)
			{
				$monto_isr=round((($total_ingreso-423)*$legaltax[0]['isr']), 2);
			}	
			$count=0;
			$cod1="";$monto1="";$pendiente1="";
			$cod2="";$monto2="";$pendiente2="";
			$cod3="";$monto3="";$pendiente3="";
			$cod4="";$monto4="";$pendiente4="";
			$cod5="";$monto5="";$pendiente5="";
			$cod6="";$monto6="";$pendiente6="";
			
		
			foreach($discountsincomeemployees as $discountsincomeemployee){
			
				if($discountsincomeemployee['monto_pendiente']>0){
				    $count++;
					$fecha_ultimo_pago = date("Y/m/d");
					$cantidad_pago =$discountsincomeemployee['cantidad_pago']+1;
					$monto_pendiente =$discountsincomeemployee['monto_pendiente']-$discountsincomeemployee['monto_periodo'];
					$monto_periodo=$discountsincomeemployee['monto_periodo'];
					$total_monto_periodo=$total_monto_periodo+$monto_periodo;
					
					$monto_pendiente =number_format((float)$monto_pendiente, 2, '.', ''); 
					$monto_periodo =number_format((float)$monto_periodo, 2, '.', ''); 
					$total_monto_periodo=number_format((float)$total_monto_periodo, 2, '.', ''); 
					
					if($count==1){$cod1=$discountsincomeemployee['cod_descuento_ingreso'];$monto1=$monto_periodo;$pendiente1=$monto_pendiente;}
					elseif($count==2){$cod2=$discountsincomeemployee['cod_descuento_ingreso'];$monto2=$monto_periodo;$pendiente2=$monto_pendiente;}
					elseif($count==3){$cod3=$discountsincomeemployee['cod_descuento_ingreso'];$monto3=$monto_periodo;$pendiente3=$monto_pendiente;}
					elseif($count==4){$cod4=$discountsincomeemployee['cod_descuento_ingreso'];$monto4=$monto_periodo;$pendiente4=$monto_pendiente;}
					elseif($count==5){$cod5=$discountsincomeemployee['cod_descuento_ingreso'];$monto5=$monto_periodo;$pendiente5=$monto_pendiente;}
					else{$cod6="OTROS";$monto6=$monto6+$monto_periodo;$pendiente6=$pendiente6+$monto_pendiente;}
					
					$param = array('id_descuento_ingreso_empleado' =>$discountsincomeemployee['id_descuento_ingreso_empleado'], 'numero_cliente' =>$discountsincomeemployee['numero_cliente'], 
											'numero_cuenta' =>$discountsincomeemployee['numero_cuenta'],'id_descuento_ingreso' =>$discountsincomeemployee['id_descuento_ingreso'],
											'monto_mes' =>$discountsincomeemployee['monto_mes'],'monto_periodo' =>$discountsincomeemployee['monto_periodo'], 
											'afecta_diciembre' =>$discountsincomeemployee['afecta_diciembre'],'prioridad' =>$discountsincomeemployee['prioridad'],
											'tipo' =>$discountsincomeemployee['tipo'],'frecuencia' =>$discountsincomeemployee['frecuencia'],
											'monto_urgente' =>$discountsincomeemployee['monto_urgente'],'monto_original' =>$discountsincomeemployee['monto_original'], 
											'monto_pendiente' =>$monto_pendiente,'estado' =>$discountsincomeemployee['estado'],
											'referencia' =>$discountsincomeemployee['referencia'],'id_periodo' => $id_periodo,
											'fecha_ultimo_pago' =>$fecha_ultimo_pago,'cantidad_pago' =>$cantidad_pago,
											'id_usuario' =>$discountsincomeemployee['id_usuario']); 
					$resultDiscountsIncomeEmployee = $client->call('EditDiscountsIncomeEmployeeByid',$param,'','','',true);
				}	
									
				
				
			}
			if($discountsincomeemployees[0]['id_descuento_ingreso_empleado']!=null){
				$param = array('id_empleado' => $id_empleado,'cod1' => $cod1,'cod2' => $cod2,'cod3' => $cod3,'cod4' => $cod4,'cod5' => $cod5,'cod6' => $cod6,
								'monto1' => $monto1,'monto2' => $monto2,'monto3' => $monto3,'monto4' => $monto4,'monto5' => $monto5,'monto6' => $monto6,
								'pendiente1' => $pendiente1,'pendiente2' => $pendiente2,'pendiente3' => $pendiente3,'pendiente4' => $pendiente4,'pendiente5' => $pendiente5,'pendiente6' => $pendiente6,
							'estado' => $estado,'id_periodo' => $id_periodo,'id_empresa' => $id_empresa,'id_usuario' => $id_usuario);
				$resultDiscountsIncomeEmployeeDetail = $client->call('AddDiscountsIncomeEmployeeDetail',$param,'','','',true);
			}
			$total_descuento=$monto_isr+$monto_ss+$monto_se+$total_monto_periodo;
			
			$param = array('id_empleado' => $id_empleado, 'numero_empleado' =>$numero_empleado,'monto_ss' => $monto_ss, 'monto_se' => $monto_se,'monto_isr' => $monto_isr,'id_periodo' => $id_periodo,'id_impuesto_legal' => $legaltax[0]['id_impuesto_legal']); 
			$resultLegalTaxEmployee = $client->call('AddLegalTaxEmployee',$param,'','','',true);
			
			
			$param = array('id_empleado' => $id_empleado,'numero_empleado' => $numero_empleado,'id_periodo' => $id_periodo,'id_seccion' => $id_seccion,'nombre_seccion' => $nombre_seccion,
						'nombre_departamento' => $nombre_departamento,'nombre_empleado' => $nombre_empleado,'apellido_empleado' => $apellido_empleado,'cedula_empleado' => $cedula_empleado,'id_empresa' => $id_empresa,
						'nombre_empresa' => $nombre_empresa,'rataxhora' => $rataxhora,'claveir' => $claveir,'numero_comprobante' => $numero_comprobante,'numero_cuenta' => $numero_cuenta,
						'id_tipo_cuenta' => $id_tipo_cuenta,'id_banco' => $id_banco,'total_ingreso' => $total_ingreso,'total_descuento' => $total_descuento);
			$result = $client->call('AddReceiptsEmployees',$param,'','','',true);
	
		}
	
	}
	else{
		header('Content-type: application/json');
		$json = array("status" => 2, "info" => $result);
		echo json_encode($json);
		exit();

    
	}
	
}
else
{
$param = array(); 
	$result = $client->call('GetPeriodByStatus',$param,'','','',true);

		header('Content-type: application/json');
		$json = array("status" => 1,"info" => $result);
		echo json_encode($json);
		exit();
}
if ($client->fault) {
    echo 'Fault';
    print_r($result);
    echo '';
} 
else 
{
// Check for errors
    $err = $client->getError();
    if ($err) {
        // Display the error
        echo 'Error:'.$err;
    } 
	else 
	{
        // Display the result
        if($result!=false)
         {
			header('Content-type: application/json');
			if($result[0]['msg']!='OK')
			{
				$json = array("status" => 0, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 1, "info" => $result);
				
				
			}
			echo json_encode($json);
         }
    }
}
function distribucionhoras($id_empresa, $id_periodo, $anno_fiscal) {
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";
$client = new nusoap_client($wsdl,true); 
$result="";

		$param = array('id_empresa' => $id_empresa); 
		$employees = $client->call('GetEmployeeByidCompany',$param,'','','',true);
		
		
		
		
		
		//$param = array('id_periodo' => $id_periodo); 
		//$periods = $client->call('GetPeriodByid',$param,'','','',true);
		
		foreach($employees as $employee){ 
			$id_empleado=$employee['id_empleado'];
			$horas_regular="104.00";$horas_domingo="0.00";$horas_feriado="0.00";$horas_compensatorio="0.00";
			$horas_extra1="0.00";$horas_extra2="0.00";$horas_extra3="0.00";$horas_extra4="0.00";$horas_extra5="0.00";
			$horas_extra6="0.00";$horas_extra7="0.00";$horas_extra8="0.00";$horas_extra9="0.00";$horas_extra10="0.00";
			$factor_reg="1.0000";$factor_dom="1.5000";$factor_fer="2.5000";$factor_com="0.5000"; 
			$factor1="0.0000";$factor2="0.0000";$factor3="0.0000"; $factor4="0.0000";$factor5="0.0000";
			$factor6="0.0000";$factor7="0.0000";$factor8="0.0000";$factor9="0.0000";$factor10="0.0000";
			$horas_enferm="0.00";$horas_ajuste="0.00";$horas_ausen="0.00";$horas_certmedic="0.00";$adelanto_vacaciones="0.00";
			
			$param = array('id_empleado' => $id_empleado,'id_periodo' => $id_periodo,'anno_fiscal' => $anno_fiscal); 
			$workingdayemployees= $client->call('GetWorkingDayEmployeeByPeriod',$param,'','','',true);
			
			
			
			if($workingdayemployees[0]['id_jornada_empleado']!=null) 
			{
				$horas_regular="0.00";
				foreach($workingdayemployees as $wdayemployee){ 
					if($wdayemployee['laboro']==1){
						if($wdayemployee['tipo']=='R'){
							$horas_regular=$horas_regular+$wdayemployee['horas_regulares'];
							$horas_regular =number_format((float)$horas_regular, 2, '.', ''); 
						}elseif($wdayemployee['tipo']=='D'){
							$horas_domingo=$horas_domingo+$wdayemployee['horas_regulares'];
							$horas_domingo =number_format((float)$horas_domingo, 2, '.', ''); 
						}elseif($wdayemployee['tipo']=='F'){
							$horas_feriado=$horas_feriado+$wdayemployee['horas_regulares'];
							$horas_feriado =number_format((float)$horas_feriado, 2, '.', ''); 
						}
						else{
							$horas_compensatorio=$horas_compensatorio+$wdayemployee['horas_regulares'];
							$horas_compensatorio =number_format((float)$horas_compensatorio, 2, '.', ''); 
						}
					}
				}
				
			}
			$param = array('id_empleado' => $id_empleado, 'id_empresa' => $id_empresa,'id_periodo' => $id_periodo,
						 'horas_regular' => $horas_regular, 'horas_domingo' => $horas_domingo, 
						  'horas_feriado' => $horas_feriado, 'horas_compensatorio' => $horas_compensatorio,
						  'horas_extra1' => $horas_extra1,'horas_extra2' => $horas_extra2, 'horas_extra3' => $horas_extra3, 'horas_extra4' => $horas_extra4, 'horas_extra5' => $horas_extra5,
						  'horas_extra6' => $horas_extra6,'horas_extra7' => $horas_extra7, 'horas_extra8' => $horas_extra8, 'horas_extra9' => $horas_extra9, 'horas_extra10' => $horas_extra10,
						  'factor_reg' => $factor_reg,'factor_dom' => $factor_dom, 'factor_fer' => $factor_fer, 'factor_com' => $factor_com, 
						  'factor1' => $factor1, 'factor2' => $factor2, 'factor3' => $factor3, 'factor4' => $factor4, 'factor5' => $factor5,
						  'factor6' => $factor6, 'factor7' => $factor7, 'factor8' => $factor8, 'factor9' => $factor9, 'factor10' => $factor10,
						   'horas_enferm' => $horas_enferm, 'horas_ajuste' => $horas_ajuste, 'horas_ausen' => $horas_ausen, 'horas_certmedic' => $horas_certmedic, 'adelanto_vacaciones' => $adelanto_vacaciones);	
					$resultEmployeeRecordTransaction= $client->call('AddEmployeeRecordTransaction',$param,'','','',true);

			
		}
     //return $result;
	}

		
?>
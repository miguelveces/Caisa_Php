<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultGender="";
$resultStatesCivil="";
$resultStatesEmployee="";
$horasregulares="";
$horasextras="";
$rataxjornada="";
$horasregular="";
$horasdomingo="";
$horasferiado="";
$horascompensatorio="";
$horasextra1="";
$horasextra2="";
$horasextra3="";
$horasextra4="";
$horasextra5="";
$horasextra6="";
$horasextra7="";
$horasextra8="";
$horasextra9="";
$horasextra10="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){	
}
else
{

	

    $id_empresa = isset($_SESSION['id_empresa']) ? mysqli_real_escape_string($connect, $_SESSION['id_empresa']) :  "";
    $id_empleado = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	$param = array('id_empleado' => $id_empleado); 
	$result = $client->call('GetEmployeeByid',$param,'','','',true);
	$rataxhora = $result[0]['rata_x_hora']; 
	
	$genders = $client->call('GetAllGenders',$param,'','','',true);
	foreach($genders as $gender){ 
		$resultGender.='<option value='.$gender['id_genero'].' '.($gender['id_genero'] == $result[0]['id_genero'] ? 'selected="selected"' : "").'>'.$gender['nombre_genero'].'</option>';
	} 
	
	$statescivil = $client->call('GetAllStatesCivil',$param,'','','',true); 
	foreach($statescivil as $statecivil){ 
		$resultStatesCivil.='<option value='.$statecivil['id_estado_civil'].' '.($statecivil['id_estado_civil'] == $result[0]['id_estado_civil'] ? 'selected="selected"' : "").'>'.$statecivil['nombre_estado_civil'].'</option>';
	} 
	
	$statesemployees = $client->call('GetAllStatesEmployees',$param,'','','',true);
	foreach($statesemployees as $stateemployees){ 
		$resultStatesEmployee.='<option value='.$stateemployees['id_estado_empleado'].' '.($stateemployees['id_estado_empleado'] == $result[0]['id_estado_empleado'] ? 'selected="selected"' : "").'>'.$stateemployees['nombre_estado_empleado'].'</option>';
	}


	$param = array(); 
	$period = $client->call('GetPeriodByStatus',$param,'','','',true);
    $id_periodo=$period[0]['id_periodo'];
	$anno_fiscal=$period[0]['anno_fiscal'];

	

	$param = array('id_empresa' => $id_empresa,'id_periodo' =>$id_periodo); 
	$resultEmployeesRecordsTransactions = $client->call('GetEmployeesRecordsTransactionsByCompany',$param,'','','',true);
	
    if($resultEmployeesRecordsTransactions[0]['msg']=='False'){
	
		$horas_regular="104.00";$horas_domingo="0.00";$horas_feriado="0.00";$horas_compensatorio="0.00";
		$horas_extra1="0.00";$horas_extra2="0.00";$horas_extra3="0.00";$horas_extra4="0.00";$horas_extra5="0.00";
		$horas_extra6="0.00";$horas_extra7="0.00";$horas_extra8="0.00";$horas_extra9="0.00";$horas_extra10="0.00";
		$factor_reg="1.0000";$factor_dom="1.5000";$factor_fer="2.5000";$factor_com="0.5000"; 
		$factor1="0.0000";$factor2="0.0000";$factor3="0.0000"; $factor4="0.0000";$factor5="0.0000";
		$factor6="0.0000";$factor7="0.0000";$factor8="0.0000";$factor9="0.0000";$factor10="0.0000";
	
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
		$horasregular=$horas_regular*$factor_reg*$rataxhora;
		$horasdomingo=$horas_domingo*$factor_dom*$rataxhora;
		$horasferiado=$horas_feriado*$factor_fer*$rataxhora;
		$horascompensatorio=$horas_compensatorio*$factor_com*$rataxhora;
		$horasextra1=$horas_extra1*$factor1*$rataxhora;
		$horasextra2=$horas_extra2*$factor2*$rataxhora;
		$horasextra3=$horas_extra3*$factor3*$rataxhora;
		$horasextra4=$horas_extra4*$factor4*$rataxhora;
		$horasextra5=$horas_extra5*$factor5*$rataxhora;
		$horasextra6=$horas_extra6*$factor6*$rataxhora;
		$horasextra7=$horas_extra7*$factor7*$rataxhora;
		$horasextra8=$horas_extra8*$factor8*$rataxhora;
		$horasextra9=$horas_extra9*$factor9*$rataxhora;
		$horasextra10=$horas_extra10*$factor10*$rataxhora;

	
	}
	else{
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
	}
	
	$total_ingreso=$horasregular+$horasdomingo+$horasferiado+$horascompensatorio+$horasextra1+$horasextra2+$horasextra3+$horasextra4+$horasextra5+$horasextra6+$horasextra7+$horasextra8+$horasextra9+$horasextra10;

		$param = array();
		$legaltax = $client->call('GetLegalTaxesByStatus',$param,'','','',true);
		
		$monto_isr="0.00";
		$monto_ss= round(($total_ingreso*$legaltax[0]['segsoc']), 2);
		$monto_se= round(($total_ingreso*$legaltax[0]['segedu']), 2);
		if($total_ingreso > 423)
		{
			$monto_isr=round((($total_ingreso-423)*$legaltax[0]['isr']), 2);
		}	

$result=$result+array('monto_ss' => $monto_ss, 'monto_se' => $monto_se,'monto_isr' => $monto_isr); 
header('Content-type: application/json');
$json = array("status" => 1,"info" => $result, "gender" => $resultGender, "statescivil" => $resultStatesCivil, "statesemployee" => $resultStatesEmployee);
echo json_encode($json);
exit();
}

// fault if any
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
			if($result[0]['msg']=='OK')
			{
				$json = array("status" => 1, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 0, "info" => $result);
				
				
			}
			echo json_encode($json);
         }
    }
}		
?>
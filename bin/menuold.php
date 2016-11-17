<?php
session_start();
$result="";
$result='<div id="sidebar-left" class="span2"><div class="nav-collapse sidebar-nav collapse navbar-collapse bs-navbar-collapse"><ul class="nav nav-tabs nav-stacked main-menu">';
$result.='<li>
	<a class="dropmenu" href="#"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Inicio</span><span class="label">1</span></a>
		<ul>
		    <li><a class="submenu" href="form_inicio.html"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Bienvenido</span></a></li>
			
			
		</ul>	
</li>';
if($_SESSION['id_rol']==1){	
$result.='<li>
	<a class="dropmenu" href="#"><i class="icon-group"></i><span class="hidden-tablet">Seguridad</span> <span class="label">2</span></a>
		<ul>
			<li><a class="submenu" href="form_empresaList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Empresas</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_usuarioList.html"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Usuarios</span></a></li>
		</ul>	
</li>';
}
if($_SESSION['id_rol']==1 || $_SESSION['id_rol']==2){	
$result.='<li>
	<a class="dropmenu" href="#"><i class="icon-group"></i><span class="hidden-tablet">Mantenimiento</span> <span class="label">5</span></a>
		<ul>
			
			<li><a class="submenu" href="form_descuento_ingresoList.html"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Descuento/Ingreso</span></a></li>
			<li><a class="submenu" href="form_departamentoList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Departamentos</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_seccionList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Secciones</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_cargoList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Cargos</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_jornadaList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Jornadas</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_dia_feriadoList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Dias Feriados</span><span class="label"></span></a></li>
			
		</ul>	
</li>
<li>
	<a class="dropmenu" href="#"><i class="icon-group"></i><span class="hidden-tablet">Catalogos</span> <span class="label">1</span></a>
		<ul>
           <li><a class="submenu" href="form_catalogoList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Lista Catalogo</span><span class="label"></span></a></li>  
		</ul>	
</li>
<li>
	<a class="dropmenu" href="#"><i class="icon-group"></i><span class="hidden-tablet">Empleado</span> <span class="label">1</span></a>
		<ul>
            <li><a class="submenu" href="form_empleadoList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Datos Generales</span><span class="label"></span></a></li>        
		</ul>	
</li>
<li>
	<a class="dropmenu" href="#"><i class="icon-money"></i><span class="hidden-tablet">Calculos/Planilla</span> <span class="label">3</span></a>
		<ul>
            <li><a class="submenu" href="form_periodoList.html"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Periodos</span></a></li>
			<li><a class="submenu" href="form_empleado_calculo_planilla_regular.html"><i class="icon-hdd"></i><span class="hidden-tablet">Planilla Regular</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_calculo_planilla_quincenal.html"><i class="icon-hdd"></i><span class="hidden-tablet">Calculo Planilla Quincenal</span><span class="label"></span></a></li>
                        
		</ul>	
</li>
<li>
	<a class="dropmenu" href="#"><i class="icon-group"></i><span class="hidden-tablet">Reporte/Informes</span> <span class="label">2</span></a>
		<ul>
			<li><a class="submenu" href="form_reporte_talonario.html"><i class="icon-hdd"></i><span class="hidden-tablet">Reporte Talonario</span><span class="label"></span></a></li>
            <li><a class="submenu" href="form_informeList.html"><i class="icon-hdd"></i><span class="hidden-tablet">Lista Informe</span><span class="label"></span></a></li>        
		</ul>	
</li>';
}
$result.='</ul></div></div>';

header('Content-type: application/json');
$json = array("status" => 1, "info" => $result);
echo json_encode($json);
	
?>
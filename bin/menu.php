<?php
session_start();
$result="";
$result='<div id="sidebar-left" class="span2"><div class="nav-collapse sidebar-nav collapse navbar-collapse bs-navbar-collapse"><ul class="nav nav-tabs nav-stacked main-menu">';
$result.='<li>
	<a class="dropmenu" href="#"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Inicio</span><span class="label">1</span></a>
		<ul>
		    <li><a class="submenu" href="form_inicio.html"><i class="icon-minus"></i><span class="hidden-tablet">Bienvenido</span></a></li>
			
			
		</ul>	
</li>';
if($_SESSION['id_rol']==1){	
$result.='<li>
	<a class="dropmenu" href="#"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Seguridad</span> <span class="label">2</span></a>
		<ul>
			<li><a class="submenu" href="form_empresaList.html"><i class="icon-minus"></i><span class="hidden-tablet">Empresas</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_usuarioList.html"><i class="icon-minus"></i><span class="hidden-tablet">Usuarios</span></a></li>
		</ul>	
</li>';
}
if($_SESSION['id_rol']==1 || $_SESSION['id_rol']==2){	
$result.='<li>
	<a class="dropmenu" href="#"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Administracion</span> <span class="label">2</span></a>
		<ul>
			<li><a class="submenu" href="form_mantenimientoList.html"><i class="icon-minus"></i><span class="hidden-tablet">Lista Mantenimientos</span><span class="label"></span></a></li>  
			<li><a class="submenu" href="form_catalogoList.html"><i class="icon-minus"></i><span class="hidden-tablet">Lista Catalogos</span><span class="label"></span></a></li>        
			
		</ul>	
</li>
<li>
	<a class="dropmenu" href="#"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Empleado</span> <span class="label">2</span></a>
		<ul>
            <li><a class="submenu" href="form_empleadoList.html"><i class="icon-minus"></i><span class="hidden-tablet">Datos Generales</span><span class="label"></span></a></li>
			<li><a class="submenu" href="form_acumuladoList.html"><i class="icon-minus"></i><span class="hidden-tablet">Acumulados</span><span class="label"></span></a></li>
		</ul>	
</li>
<li>
	<a class="dropmenu" href="#"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Calculos/Planilla</span> <span class="label">1</span></a>
		<ul>
            
			<li><a class="submenu" href="form_procesos.html"><i class="icon-minus"></i><span class="hidden-tablet">Procesos</span><span class="label"></span></a></li>
		
                        
		</ul>	
</li>
<li>
	<a class="dropmenu" href="#"><i class="icon-folder-close-alt"></i><span class="hidden-tablet">Reporte/Informes</span> <span class="label">3</span></a>
		<ul>
		<li><a class="submenu" href="form_informeList.html"><i class="icon-minus"></i><span class="hidden-tablet">Lista Informes</span><span class="label"></span></a></li>        
		<li><a class="submenu" href="form_reporteList.html"><i class="icon-minus"></i><span class="hidden-tablet">Lista Reportes</span><span class="label"></span></a></li>        
		
			<li><a class="submenu" href="form_reporte_talonario.html"><i class="icon-minus"></i><span class="hidden-tablet">Reporte Talonario</span><span class="label"></span></a></li>
           
		</ul>	
</li>';
}
$result.='</ul></div></div>';

header('Content-type: application/json');
$json = array("status" => 1, "info" => $result);
echo json_encode($json);
	
?>
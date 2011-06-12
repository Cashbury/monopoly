.fan_box .full_widget {
	background: none; border: none;
}

.fan_box .full_widget .connect_top	{
	background: transparent;
	padding: 0px;
	
}


.connect_top	{
	position: absolute;
	top:0px;
	left:0px;
	width:200px;
}

.connections	{
	position: absolute;
	right: 0px;
	top:0px;
	padding: 0px !important;
	border-top: 0px !important;
	min-height: 0px !important;
}

.connections_grid	{
	padding-top: 0px;
}

.connections .total	{
	font-weight: bold
}

.connect_widget .connect_text_wrapper .connect_widget_facebook_favicon	{
	display: none;
	background: none;
}
.fan_box .connect_top{
	float:left!important;
}
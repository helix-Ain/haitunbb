<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Vaccineinoculation.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.Vaccineinoculation" %>

<!DOCTYPE html>
<html ng-app='app'>

	<head>
		<title>宝宝366</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">
		<link rel='stylesheet' href='CSS/Ionic/ionic.min.css' />
		<script src="JS/Ionic/ionic.bundle.min.js"></script>
		<script src="JS/Constants.js"></script>
		<script src="JS/Common.min.js?v=1.0"></script>
		<script src="JS/Health.js?v=1.0"></script>
		<style>
			span.scope {
				font-size: 14px;
				color: #51ADD6;
				display: inline-block;
				margin-top: 3px;
			}
			
			div.instance {
				float: left;
			}
			
			button.v1 {
				height: 35px;
				color: #FFFFFF;
				background-color: #FF5658;
				border: none;
				border-radius: 3px;
				float: right;
				line-height: 35px;;
			}
			
			button.v2 {
				height: 35px;
				color: #8D8D8D;
				background-color: #DCDCDC;
				border: none;
				border-radius: 3px;
				float: right;
				line-height: 35px;;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;疫苗接种</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<ion-item ng-repeat='item in vaccines' style='cursor: pointer;' ng-click='detail(item.iID)'>
					<div class='instance'>
						{{item.cName}}<br />
						<span class='scope'><span>{{item.fBeginAge}}</span>到<span>{{item.fEndAge}}</span></span>
					</div>
					<button disabled="disabled" ng-class='item.nClass'>{{item.result}}</button>
				</ion-item>
			</ion-list>
		</ion-content>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.vaccines = [];
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}
                $scope.detail = function(iID){
                	location = 'VaccineinoculationDetail.aspx?iID='+iID;
                }
				function initPage() {
					commonService.postData({
						url:'DcCdHealthVaccineManage',
						params:{
							Action:'GetList',
							page:1,
							rows:10,
							sort:'iOrderNo',
							order:'asc'
						},
						success:function(ci_result){
							if(existData(ci_result)){
								var m_objData = ci_result.rows;
								$scope.vaccines = [];
								angular.forEach(m_objData,function(value,key){
								    value.nClass = ['v1'];
									value.result = '未接种';
					                $scope.vaccines.push(value);
								});
								window.console.log($scope.vaccines);
								commonService.postData({
									url:'DcCdHealthVaccineStudentManage',
									params:{
										Action:'GetList',
										Type:'U'
									},
									success:function(ci_result){
										if(existData(ci_result)){
											var m_objData = ci_result.rows;
											angular.forEach(m_objData,function(value1,key1){
												 angular.forEach($scope.vaccines,function(value2,key2){
												 	if(value1.iVaccineID == value2.iID){
												 		value2.nClass = ['v2'];
												 		value2.result = '已接种';
												 	}
												 });
											});
										}
									}
								});
								angular.forEach($scope.vaccines,function(value,key){
									value.fBeginAge = ageToStr(value.fBeginAge);
									value.fEndAge = ageToStr(value.fEndAge);
								});
							}else{
								commonService.showAlert('记录不存在或已删除');
							}
						}
					});
				}
				
				function ageToStr(age){
					age = age.toFixed(1);
                    var year = Math.floor(age);
                    var month = age%1;
                    age = year + '岁';
                    switch(month){
                    	case 0:break;
                    	case 0.5:age += '半';break;
                    	default:age += month+'个月';break;
                    }
                    return age;
				}
			});
			
			function back(){
				history.back();
			}
		</script>
	</body>

</html>
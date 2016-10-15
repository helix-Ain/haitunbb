<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VaccineinoculationDetail.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.VaccineinoculationDetail" %>

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
			button.activityBtn {
				color: #FFFFFF;
				background-color: #01C3FF;
				border: none;
				border-radius: 5px;
				width: 35%;
				height: 30px;
				font-size: 15px;
				line-height: 30px;
			}
			
			button.notactivityBtn {
				color: #FFFFFF;
				background-color: #7ADEFE;
				border: none;
				border-radius: 5px;
				width: 35%;
				height: 30px;
				font-size: 15px;
				line-height: 30px;
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
				<ion-item style='text-align: center;border:none;padding-bottom: 5px;'>
					<h2 style='color:#787878;letter-spacing: 1px;' ng-bind-html='app.cName'></h2>
				</ion-item>
				<ion-item style='border:none;padding-bottom: 5px;'>
					<p style='white-space: normal;letter-spacing: 1px;' ng-bind-html='app.cExplain'></p>
				</ion-item>
				<ion-item style='border:none;'>
					<p style='margin-bottom: 10px;color:#6CC8F9;'>注意事项:</p>
					<p style='white-space: normal;letter-spacing: 1px;' ng-bind-html='app.cNotes'></p>
				</ion-item>
			</ion-list>
		</ion-content>
		<ion-footer-bar style='padding:10px;border-top:1px solid #DDDDDD;'>
			<h1 class='title' style='text-align: center;'>
			  <button style='margin-right: 15px;' ng-class="{true:'notactivityBtn',false: 'activityBtn'}[status]" ng-click='vaccinate()'>已接种</button>
			  <button ng-class="{true: 'activityBtn', false: 'notactivityBtn'}[status]" ng-click='notvaccinate()'>未接种</button>
			</h1>
		</ion-footer-bar>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}

				$scope.vaccinate = function() {
				    if($scope.status){
				    	return;
				    }
					commonService.postData({
						url: 'DcCdHealthVaccineStudentManage',
						params: {
							Action: 'Add',
							Type: 'U',
							iVaccineID: $scope.iID
						},
						success: function(ci_result) {
							if(ci_result.DcCode == 0) {
								commonService.showAlert('保存成功');
								$scope.status = true;
							} else {
								commonService.showAlert('保存失败');
							}
						}
					});
				}
                
                $scope.notvaccinate = function(){
                	if(!$scope.status){
                		return;
                	}
                	commonService.postData({
                		url:'DcCdHealthVaccineStudentManage',
                		params:{
                			Action:'Delete',
                			cIDList:$scope.cIDList
                		},
                		success:function(ci_result){
                			if(ci_result.DcCode == 0){
                				commonService.showAlert('保存成功');
                				$scope.status = false;
                			}else{
                				commonService.showAlert('保存失败');
                			}
                		}
                	});
                }
                
				function initPage() {
					$scope.iID = getQueryStringValue('iID');
					$scope.status = false;
					$scope.app = {
						cName:'',
						cExplain:'',
						cNotes:''
					};
					commonService.postData({
						url: 'DcCdHealthVaccineManage',
						params: {
							Action: 'GetList',
							iID: $scope.iID
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.app.cName = html_decode(m_objData.cName);
								$scope.app.cExplain = html_decode(m_objData.cExplain);
								$scope.app.cNotes = html_decode(m_objData.cNotes);
								commonService.postData({
									url: 'DcCdHealthVaccineStudentManage',
									params: {
										Action: 'GetList',
										Type: 'U'
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var m_objData = ci_result.rows;
											angular.forEach(m_objData, function(value, key) {
												if(value.iVaccineID == $scope.iID) {
													$scope.status = true;
													$scope.cIDList = value.iID;
													return false;
												} 
											});
										}
									}
								});
							} else {
								commonService.showAlert('记录不存在或已删除');
							}
						}
					});
				}
			});
			
			function back(){
				history.back();
			}
		</script>
	</body>

</html>
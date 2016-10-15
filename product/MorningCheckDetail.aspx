<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MorningCheckDetail.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.MorningCheckDetail" %>

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
			.item {
				padding: 9px;
				line-height: 25px;
			}
			
			span.colu {
				display: inline-block;
				width: 50%;
				font-size: 15px;
				text-align: center;
			}
			
			img.tag {
				display: inline-block;
				width: 25px;
				height: 25px;
				margin-bottom: -7px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick='back()'>返回</button>
			<h1 class='title' style='font-weight: 100;'>&nbsp;&nbsp;&nbsp;&nbsp;{{date}}晨检明细</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<div class='list list-inset'>
				<ion-item style='background-color: #53C6FD;color:#FFFFFF;border:none;'>
					<span class='colu'>项目</span><span class='colu'>结果</span>
				</ion-item>
				<ion-item>
					<span class='colu'>体温</span><span class='colu' ng-bind='cBbtStatusDesc' ng-style='cBbtStatusStyle'></span>
				</ion-item>
				<ion-item ng-repeat='item in symps'>
					<span class='colu'>{{item.cDesc}}</span><span class='colu'><img ng-src='{{item.src}}' class='tag'/></span>
				</ion-item>
			</div>
		</ion-content>
		<script>
			var _date = getQueryStringValue('date');
			var _interim = getQueryStringValue('interim');
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.symps = [];
				$scope.date = _date;
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}

				function initPage() {
					commonService.postData({
						url: '../../Ajax/DcCdCodeMasterManage',
						params: {
							Action: 'Combo',
							Cat: 'Health',
							SubCat: 'Symp'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								commonService.postData({
									url: 'DcCdHealthCheckManage',
									params: {
										Action: 'GetList',
										Type: 'U',
										StartDate: new Date(_date).toLocaleDateString(),
										EndDate: new Date(_date).toLocaleDateString()
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var healthCheck = ci_result.rows[0];
											if(healthCheck.iBbtStatus == 1) {
												$scope.cBbtStatusDesc = healthCheck.cBbtStatusDesc;
											} else if(healthCheck.iBbtStatus == 2) {
												$scope.cBbtStatusDesc = healthCheck.fBbt + '℃';
												$scope.cBbtStatusStyle = {
													color: '#20E01E'
												};
											} else {
												$scope.cBbtStatusDesc = healthCheck.fBbt + '℃';
												$scope.cBbtStatusStyle = {
													color: '#EF2203'
												};
											}
											var cSympValues = healthCheck.cSympValues.split(',');
											angular.forEach(m_objData, function(value, key) {
												if(cSympValues.indexOf(value.cCodeItem) != -1) {
													value.on = true;
													value.src = '/CI/Mobile/Image/health_zan.png'
												} else {
													value.on = false;
													value.src = '/CI/Mobile/Image/health_weizan.png';
												}
											});
											$scope.symps = m_objData;
										} else {
											$scope.cBbtStatusDesc = '未检';
											angular.forEach(m_objData, function(value, key) {
												value.on = false;
												value.src = '/CI/Mobile/Image/health_weizan.png';
											});
											$scope.symps = m_objData;
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

			function back() {
				if(_interim == '' || _interim == undefined) {
					var myDate = new Date(_date);
					location = 'MorningCheckRecord.aspx?date=' + myDate.getFullYear() + '-' + (myDate.getMonth() + 1);
				}else{
					location = 'HealthCenter.aspx';
				}
			}
		</script>
	</body>

</html>
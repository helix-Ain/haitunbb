<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HealthEvaluation.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.HealthEvaluation" %>

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
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;健康评测</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<ion-item style='padding:0;height:125px;'>
					<img src="/CI/Mobile/Image/health_peitu.png" style='width:100%;height:100%;' />
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item style='line-height: 30px;'>
					<span>生活习惯</span>
					<button style='float:right;height:30px;font-size:15px;line-height: 30px;background-color:#FE8AB3;color:#FFFFFF;border:none;border-radius: 3px;' ng-click='evaluating(1)'>&nbsp;{{evalTip1}}&nbsp;</button>
				</ion-item>
				<ion-item style='line-height:30px;'>
					<label>日常饮食</label>
					<button style='float:right;height:30px;font-size:15px;line-height: 30px;background-color:#7ADAFA;color:#FFFFFF;border:none;border-radius: 3px;' ng-click='evaluating(2)'>&nbsp;{{evalTip2}}&nbsp;</button>
				</ion-item>
				<ion-item style='line-height:30px;'>
					<label>常见病评测</label>
					<button style='float:right;height:30px;font-size:15px;line-height: 30px;background-color:#92E173;color:#FFFFFF;border:none;border-radius: 3px;' ng-click='evaluating(3)'>&nbsp;{{evalTip3}}&nbsp;</button>
				</ion-item>
			</ion-list>
		</ion-content>
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

				$scope.evaluating = function(i) {
					if(i == 1) {
						if($scope.evalTip1 == '立即评测') {
							location.href = 'Evaluating.aspx?iType=' + i;
						} else {
							location.href = 'EvaluatingResult.aspx?iType=' + i;
						}
					} else if(i == 2) {
						if($scope.evalTip2 == '立即评测') {
							location.href = 'Evaluating.aspx?iType=' + i;
						} else {
							location.href = 'EvaluatingResult.aspx?iType=' + i;
						}
					} else if(i == 3) {
						if($scope.evalTip3 == '立即评测') {
							location.href = 'Evaluating.aspx?iType=' + i;
						} else {
							location.href = 'EvaluatingResult.aspx?iType=' + i;
						}
					}

				}

				function initPage() {
					commonService.postData({
						url: 'DcCdHealthEvalStudentManage',
						params: {
							Action: 'GetList',
							Type: 'U',
							iType: 1
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								$scope.evalTip1 = '查看结果';
							} else {
								$scope.evalTip1 = '立即评测';
							}
						}
					});
					commonService.postData({
						url: 'DcCdHealthEvalStudentManage',
						params: {
							Action: 'GetList',
							Type: 'U',
							iType: 2
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								$scope.evalTip2 = '查看结果';
							} else {
								$scope.evalTip2 = '立即评测';
							}
						}
					});
					commonService.postData({
						url: 'DcCdHealthEvalStudentManage',
						params: {
							Action: 'GetList',
							Type: 'U',
							iType: 3
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								$scope.evalTip3 = '查看结果';
							} else {
								$scope.evalTip3 = '立即评测';
							}
						}
					});
				}

			});
			
			function back(){
				location='HealthCenter.aspx';
			}
		</script>
	</body>

</html>
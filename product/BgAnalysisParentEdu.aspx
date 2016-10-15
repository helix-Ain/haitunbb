<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BgAnalysisParentEdu.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.BgAnalysisParentEdu" %>

<!DOCTYPE html>
<html ng-app='app'>

	<head>
		<title>宝宝366</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">
		<link rel='stylesheet' href='CSS/Ionic/ionic.min.css' />
		<script src="JS/Ionic/ionic.bundle.min.js"></script>
		<script src="JS/chart.min.js"></script>
		<script src="JS/Constants.js"></script>
		<script src="JS/Common.min.js?v=1.0"></script>
		<script src="JS/Teacher.js?v=1.0"></script>
		<style>
			span.th,
			span.td {
				width: 50%;
				display: inline-block;
				text-align: center;
				font-size: 14px;
				color: #828282;
			}
			
			ion-item.item {
				padding-top: 12px;
				padding-bottom: 12px;
				text-align: center;
				font-size: 14px;
				padding: 10px;
			}
			
			span.tdf {
				text-align: justify;
				text-indent: 4em;
			}
			
			div.radius {
				display: inline-block;
				height: 10px;
				width: 10px;
				border: 1px solid transparent;
				border-radius: 5px;
				margin-right: 5px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/teacher_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;幼儿背景分析</h1>
		</ion-header-bar>
		<ion-tabs class="tabs-striped tabs-top tabs-background-light tabs-color-calm">
			<a class="tab-item" ng-class='{active:tab==1}' href='BgAnalysisParentEdu.aspx'>
				家长学历
			</a>
			<a class="tab-item" ng-class='{active:tab==2}' href='BgAnalysisParentTrade.aspx'>
				家长行业
			</a>
			<a class="tab-item" href='BgAnalysisParentOutlander.aspx'>
				父母是否外地&nbsp;&gt;
			</a>
		</ion-tabs>
		<ion-content class='has-tabs-top'>
			<ion-list>
				<ion-item style='text-align: center;padding-bottom: 25px;'>
					<canvas id='myChart' wdith='200' height='200'></canvas>
					<span style='position:absolute;bottom:1%;left:37%;color:#9F9F9F;font-size:15px;font-weight: 500;'>家长学历分布图</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item><span class='th'>学历</span><span class='th'>人数</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#A9D86E;' class='radius'></div>未填写</span><span class='td'>4</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F9A415;' class='radius'></div>本科</span><span class='td'>1</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#57C749;' class='radius'></div>专科</span><span class='td'>2</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#FEE15D;' class='radius'></div>硕士</span><span class='td'>5</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F77568;' class='radius'></div>高中</span><span class='td'>2</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#AB79FB;' class='radius'></div>初中及以下</span><span class='td'>6</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#398EFE;' class='radius'></div>博士及以上</span><span class='td'>1</span></ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
			</ion-list>
		</ion-content>
		<script>
			angular.module('app', ['ionic']).controller('app', function($scope, $timeout, $ionicLoading, $http) {
				$scope.init = function() {
					loading();
					loadChart();
					$scope.tab = 1;
				}

				function loading() {
					$ionicLoading.show({
						content: 'Loading',
						animation: 'fade-in',
						showBackdrop: true,
						maxWidth: 200,
						showDelay: 0
					});
					$timeout(function() {
						$ionicLoading.hide();
					}, 1000);
				}

				function loadChart() {
					var options = {
						segmentShowStroke: true,
						segmentStrokeColor: "#fff",
						segmentStrokeWidth: 2,
						percentageInnerCutout: 65,
						animation: true,
						animationSteps: 100,
						animationEasing: "easeOutBounce",
						animateRotate: true,
						animateScale: false,
						onAnimationComplete: null
					};
					var ctx = document.getElementById('myChart').getContext('2d');
					var data = [{
						value: 27,
						label: '未填写',
						color: '#A9D86E'
					}, {
						value: 5,
						label: '本科',
						color: '#F9A415'
					}, {
						value: 10,
						label: '专科',
						color: '#57C749'
					}, {
						value: 5,
						label: '硕士',
						color: '#FEE15D'
					}, {
						value: 3,
						label: '高中',
						color: '#F77568'
					}, {
						value: 3,
						label: '初中及以下',
						color: '#AB79FB'
					}, {
						value: 7,
						label: '博士及以上',
						color: '#398EFE'
					}];
					new Chart(ctx).Doughnut(data, options);
				}

				function loadData() {
					$http.get('', {}).success(function(result) {

					}).error(function(result) {

					});
				}

			});

			function back() {
				location = 'ReportCenter.aspx';
			}
		</script>
	</body>

</html>
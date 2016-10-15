﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BgAnalysisParentRevenus.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.BgAnalysisParentRevenue" %>

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
			<a class="tab-item" href='BgAnalysisParentTrade.aspx'>
				&lt;&nbsp;家长行业
			</a>
			<a class="tab-item" ng-class='{active:tab==1}' href='BgAnalysisParentOutlander.aspx'>
				家长是否外地
			</a>
			<a class="tab-item" ng-class='{active:tab==2}' href='BgAnalysisParentRevenue.aspx'>
				家庭年收入
			</a>
		</ion-tabs>
		<ion-content class='has-tabs-top' style='background-color: #E2EEF6;'>
			<ion-list>
				<ion-item style='text-align: center;padding-bottom: 25px;'>
					<canvas id='myChart' wdith='200' height='200'></canvas>
					<span style='position:absolute;bottom:1%;left:32%;color:#9F9F9F;font-size:15px;font-weight: 500;'>家庭收入分布图</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item><span class='th'>情况</span><span class='th'>人数</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#AADC6E;' class='radius'></div>未填写</span><span class='td'>4</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F7A414;' class='radius'></div>年收入3-6万</span><span class='td'>1</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#59C64E;' class='radius'></div>年收入3万以下</span><span class='td'>2</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F6E350;' class='radius'></div>年收入6-10万</span><span class='td'>4</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#FB736B;' class='radius'></div>年收入10万以上</span><span class='td'>1</span></ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
			</ion-list>
		</ion-content>
		<script>
			angular.module('app', ['ionic']).controller('app', function($scope, $timeout, $ionicLoading, $http) {
				$scope.init = function() {
					loading();
					loadChart();
					$scope.tab = 2;

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
						color: '#AADC6E'
					}, {
						value: 13,
						label: '年收入3-6万',
						color: '#F7A414'
					}, {
						value: 3,
						label: '年收入3万以下',
						color: '#59C64E'
					}, {
						value: 4,
						label: '年收入6-10万',
						color: '#F6E350'
					}, {
						value: 6,
						label: '年收入10万以上',
						color: '#FB736B'
					}];
					new Chart(ctx).Doughnut(data, options);
				}

				function loadData() {
					$http.get('', {}).success(function(result) {

					}).error(function(result) {

					});
				}

			});
			
			function back(){
				location='ReportCenter.aspx';
			}
		</script>
	</body>

</html>
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FlowAnalysisLeave.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.FlowAnalysisLeave" %>

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
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;入离园分析</h1>
		</ion-header-bar>
		<ion-tabs class="tabs-striped tabs-top tabs-background-light tabs-color-calm">
			<a class="tab-item" ng-class='{active:tab==1}' href='FlowAnalysisEnter.aspx'>
				入园分析
			</a>
			<a class="tab-item" ng-class='{active:tab==2}' href='FlowAnalysisLeave.aspx'>
				异常离园分析
			</a>
		</ion-tabs>
		<ion-content class='has-tabs-top'>
			<ion-list style='padding-bottom: 10px;'>
				<label class="item item-input item-select" style='height:45px;text-align: center;'>
							    <select style='right:20%;' ng-change='change(time)' ng-model='time'>
							      <option>2016.4.5-2016.8.5</option>
							      <option>2015.4.5-2015.8.5</option>
							      <option>2014.4.5-2014.8.5</option>
							    </select>
							</label>
				<ion-item style='text-align: center;padding-bottom: 25px;'>
					<canvas id='myChart' wdith='200' height='200'></canvas>
					<span style='position:absolute;bottom:1%;left:37%;color:#9F9F9F;font-size:15px;font-weight: 500;'>离园分析图</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item><span class='th'>理由</span><span class='th'>人数</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#A3DA68;' class='radius'></div>资料有误要删除</span><span class='td'>17</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#FAA314;' class='radius'></div>转学离园</span><span class='td'>5</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#51C748;' class='radius'></div>其他</span><span class='td'>8</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F7E255;' class='radius'></div>毕业离园</span><span class='td'>17</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F87265;' class='radius'></div>师资力量不足</span><span class='td'>5</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#AF78FC;' class='radius'></div>资费原因</span><span class='td'>8</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#548BF2;' class='radius'></div>未填写</span><span class='td'>8</span></ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
			</ion-list>
		</ion-content>
		<script>
			angular.module('app', ['ionic']).controller('app', function($scope, $timeout, $ionicLoading) {
				$scope.init = function() {
					loading();
					loadChart();
					$scope.tab = 2;
					$scope.time = '2016.4.5-2016.8.5';
				}

				$scope.change = function(time) {
					loading();
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
						value: 30,
						label: '资料有误要删除',
						color: '#A3DA68'
					}, {
						value: 25,
						label: '转学离园',
						color: '#FAA314'
					}, {
						value: 18,
						label: '其它',
						color: '#51C748'
					}, {
						value: 15,
						label: '毕业离园',
						color: '#F7E255'
					}, {
						value: 5,
						label: '师资力量不足',
						color: '#F87265'
					}, {
						value: 5,
						label: '资费原因',
						color: '#AF78FC'
					}, {
						value: 10,
						label: '未填写',
						color: '#548BF2'
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
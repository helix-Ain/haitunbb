﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeacherStatisticsProgress.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.TeacherStatisticsProgress" %>

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
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;师资统计</h1>
		</ion-header-bar>
		<ion-tabs class="tabs-striped tabs-top tabs-background-light tabs-color-calm">
			<a class="tab-item" ng-class='{active:tab==1}' href='TeacherStatisticsProgress.aspx'>
				学历统计
			</a>
			<a class="tab-item" ng-class='{active:tab==2}' href='TeacherStatisticsTitle.aspx'>
				职称统计
			</a>
			<a class="tab-item" ng-class='{active:tab==3}' href='TeacherStatisticsAge.aspx'>
				年龄统计
			</a>
		</ion-tabs>
		<ion-content class='has-tabs-top'>
			<ion-list>
				<ion-item style='text-align: center;padding-bottom: 25px;'>
					<canvas id='myChart' wdith='200' height='200'></canvas>
					<span style='position:absolute;bottom:1%;left:37%;color:#9F9F9F;font-size:15px;font-weight: 500;'>学历统计分布图</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item><span class='th'>学历</span><span class='th'>人数</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#A1D867;' class='radius'></div>本科</span><span class='td'>4</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F9A415;' class='radius'></div>大专</span><span class='td'>1</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#56CC4D;' class='radius'></div>未填写</span><span class='td'>2</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#4FD1F9;' class='radius'></div>其他</span><span class='td'>5</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#FBD43A;' class='radius'></div>硕士</span><span class='td'>2</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#F97069;' class='radius'></div>高中以下</span><span class='td'>0</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#A87AFC;' class='radius'></div>高中</span><span class='td'>1</span></ion-item>
				<ion-item><span class='td tdf'><div style='background-color:#166F9B;' class='radius'></div>博士</span><span class='td'>2</span></ion-item>
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
						label: '本科',
						color: '#A1D867'
					}, {
						value: 5,
						label: '大专',
						color: '#F9A415'
					}, {
						value: 10,
						label: '未填写',
						color: '#56CC4D'
					}, {
						value: 5,
						label: '其他',
						color: '#4FD1F9'
					}, {
						value: 3,
						label: '硕士',
						color: '#FBD43A'
					}, {
						value: 3,
						label: '高中以下',
						color: '#F97069'
					}, {
						value: 7,
						label: '高中',
						color: '#A87AFC'
					}, {
						value: 10,
						label: '博士',
						color: '#166F9B'
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
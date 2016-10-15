<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HeightIndex.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.HeightIndex" %>
<!DOCTYPE html>
<html ng-app='app'>

	<head>
		<title>宝宝366</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">
		<link rel='stylesheet' href='CSS/Ionic/ionic.min.css' />
		<script src="JS/Ionic/ionic.bundle.min.js"></script>
		<script src="JS/Constants.js"></script>
		<script src='JS/chart.min.js'></script>
		<script src="JS/Common.min.js?v=1.0"></script>
		<script src="JS/Health.js?v=1.0"></script>
		<style>
			span.active {
				color: #21B200;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-clock>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;健康指标</h1>
		</ion-header-bar>
		<ion-tabs class="tabs-striped tabs-top tabs-background-light tabs-color-calm">
			<a class="tab-item" ng-class='{active:tab==1}' href='HeightIndex.aspx'>
				身高指标
			</a>
			<a class="tab-item" ng-class='{active:tab==2}' href='WeightIndex.aspx'>
				体重指标
			</a>
		</ion-tabs>
		<ion-content class='has-tabs-top' style='background-color: #E2EEF6;'>
			<ion-list>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item style='text-indent: 2em;border:none;padding:10px 15px 10px;'>
					<span style='white-space: normal;font-size:15px;'>宝宝{{age}}了，宝宝的生理指标正常均值为身高：{{fMinHeight}}~{{fMaxHeight}}cm。</span>
				</ion-item>
				<ion-item style='border:none;text-align: center;padding-top:0;padding-bottom: 10px;'>
					<div ng-show='tip' style='white-space: normal;color:#FB0606;font-size:15px;line-height: 25px;'>宝宝暂时还没有生理指标记录,请为宝宝添加纪录吧</div>
					<canvas id="myChart" width="275" height="300"></canvas>
				</ion-item>
				<ion-item style='border:none;padding:0 0 10px;text-align: center;font-size: 13px;'>
					<div style='width:15px;height:15px;border:1px solid #BEC2C4;background-color:#E4FCFF ;display: inline-block;'></div>&nbsp;<span style='position:relative;top:-2px;'>绿色区间为正常参考值</span>
				</ion-item>
			</ion-list>
		</ion-content>
		<ion-footer-bar style='padding:10px;border-top:1px solid #DDDDDD;'>
			<h1 class='title' style='text-align: center;'>
				<button style='color:#FFFFFF;background-color:#01C3FF;border:none;border-radius: 5px;width:70%;height:33px;font-size:17px;line-height:35px;' onclick="location='TakeNotes.aspx'">添加记录</button>
			</h1>
		</ion-footer-bar>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.tab = 1;
				$scope.tip = false;
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
						url: 'DcCdHealthGrowupManage',
						params: {
							Action: 'GetList',
							Type: 'U',
							page: 1,
							rows: 6,
							sort: 'dDate',
							order: 'desc'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								m_objData.reverse();
								var labels = [];
								var data = [];
								var fMinHeight = [];
								var fMaxHeight = [];
								angular.forEach(m_objData, function(value, key) {
									labels.push(value.iMonth + '月');
									data.push(value.fHeight);
									fMinHeight.push(value.fMinHeight);
									fMaxHeight.push(value.fMaxHeight);
								});
								loadChart(labels, data, fMinHeight, fMaxHeight);
							} else {
								$scope.tip = true;
							}
						}
					});

					commonService.postData({
						url: 'DcCdHealthStudentManage',
						params: {
							Action: 'GetList',
							Type: 'U'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.age = getAgeStringByMonth(m_objData.iAge);
								$scope.fMinHeight = m_objData.fCMinHeight.toFixed(2);
								$scope.fMaxHeight = m_objData.fCMaxHeight.toFixed(2);
							} else {
								commonService.showAlert('记录不存在或已删除');
							}
						}
					});
				}

				function loadChart(labels, data, fMinHeight, fMaxHeight) {
					var ctx = document.getElementById("myChart").getContext("2d");
					var data = {
						labels: labels,
						datasets: [{
							fillColor: 'rgba(200,248,254,0.5)',
							strokeColor: '#FFFFFF',
							pointColor: 'transparent',
							pointStrokeColor: 'transparent',
							data: fMaxHeight
						}, {
							fillColor: 'rgba(255,255,255,1)',
							strokeColor: '#FFFFFF',
							pointColor: 'transparent',
							pointStrokeColor: 'transparent',
							data: fMinHeight
						}, {
							fillColor: 'transparent',
							strokeColor: "#6ECEEE",
							pointColor: "#6ECEEE",
							pointStrokeColor: '#FFFFFF',
							data: data
						}]
					};
					new Chart(ctx).Line(data);
				}

				function getAgeStringByMonth(m) {
					var year = parseInt(m / 12);
					var month = parseInt(m % 12);
					return year + '岁' + month + '个月';
				}
			});

			function back() {
				location = 'HealthCenter.aspx';
			}
		</script>
	</body>

</html>
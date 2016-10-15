<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChildMorningCheck.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ChildMorningCheck" %>

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
				width: 33%;
				display: inline-block;
				text-align: center;
				font-size: 14px;
				color: #828282;
			}
			
			.item {
				padding: 12px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/teacher_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;幼儿晨检报表</h1>
		</ion-header-bar>
		<ion-content class='has-header' style='background-color: #E2EEF6;'>
			<ion-list style='padding-bottom: 10px;'>
				<label class="item item-input" style='height:45px;text-align: center;'>
				    <span class="input-label"></span>
				    <input type='date' ng-change='changeTime(inputTime)' ng-model='inputTime'/>
				</label>
				<ion-item style='text-align: center;padding-bottom: 37px;'>
					<label style='position: absolute;top:29%;left:40%;color:#7D899B;font-size: 55px;'>{{percent}}</label>
					<canvas id='myChart' wdith="200" height='200'></canvas>
					<span style='position:absolute;bottom:1%;left:35%;color:#9F9F9F;font-size:15px;font-weight: 500;'>
						异常人数比例<br />
	                    <span>({{showTime}})</span>
					</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item><span class='th'>班级</span><span class='th'>异常症状人数</span><span class='th'>体温偏高人数</span></ion-item>
				<ion-item ng-repeat='item in morningInspection'>
					<span class='td'>
						{{item.cClassName}}
					</span>
					<span class='td'>
						{{item.abnormal_iBbt}}
					</span>
					<span class='td'>
						{{item.abnormal_iSymp}}
					</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
			</ion-list>
		</ion-content>
		<script>
			var _date = getQueryStringValue('date');
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.abnormal = 0;
				$scope.normal = 0;
				$scope.morningInspection = [];
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}

				$scope.changeTime = function(inputTime) {
					location = 'ChildMorningCheck.aspx?date=' + inputTime.getFullYear() + '-' + (inputTime.getMonth() + 1) + '-' + inputTime.getDate();
				}

				function initPage() {
					initTime();
					var dDate = $scope.inputTime.getFullYear() + '-' + ($scope.inputTime.getMonth() + 1) + '-' + $scope.inputTime.getDate();
					commonService.postData({
						url: 'DcCdHealthCheckManage',
						params: {
							Action: 'GetClassStatistics',
							Type: 'S',
							StartDate: dDate,
							EndDate: dDate,
							page: 1,
							rows: 999
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								angular.forEach(m_objData, function(value, key) {
									var abnormal_iBbt = parseInt(fromEmptyToZero(value.iBbtStatusCount3));
									var abnormal_iSymp = parseInt(fromEmptyToZero(value.iSympStatusCount3));
									var normal = parseInt(fromEmptyToZero(value.iBbtStatusCount2)) + parseInt(fromEmptyToZero(value.iSympStatusCount2));
									$scope.morningInspection.push({
										cClassName: value.cClassName,
										abnormal_iBbt: abnormal_iBbt,
										abnormal_iSymp: abnormal_iSymp
									});
									$scope.abnormal += abnormal_iBbt + abnormal_iSymp;
									$scope.normal += normal;
								});
								loadChart($scope.abnormal, $scope.normal);
							} else {
								commonService.showAlert('查询数据为空！');
							}
						}
					});
				}

				function initTime() {
					if(_date != undefined && _date != '') {
						var myDate = new Date(_date);
					} else {
						var myDate = new Date();
					}
					$scope.inputTime = myDate;
					$scope.showTime = formatDateToStr(myDate);
				}

				function loadChart(abnormal, normal) {
					abnormal = fromEmptyToZero(abnormal);
					normal = fromEmptyToZero(normal);
					if((abnormal + normal) != 0) {
						var abnormalRatio = ((abnormal / (abnormal + normal))*100).toFixed(0);
						var normalRatio = ((normal / (abnormal + normal))*100).toFixed(0);
					} else {
						var abnormalRatio = 0;
						var normalRatio = 100;
					}
					if(abnormalRatio == 0 && normalRatio == 0) {
						var normalRatio = 100;
						var abnormalRatio = 0;
					}
					var ctx = document.getElementById('myChart').getContext('2d');
					var data = [{
						value: abnormalRatio,
						label: '异常人数比例',
						color: '#4FB0EF'
					}, {
						value: normalRatio,
						label: '正常人数比例',
						color: '#DEF0F9'
					}];
					var options = {
						segmentShowStroke: true,
						segmentStrokeColor: "#fff",
						segmentStrokeWidth: 2,
						percentageInnerCutout: 85,
						animation: true,
						animationSteps: 100,
						animationEasing: "easeOutBounce",
						animateRotate: true,
						animateScale: false,
						onAnimationComplete: null
					};
					new Chart(ctx).Doughnut(data, options);
					$scope.percent = data[0].value + '%';
				}

				function formatDateToStr(date) {
					return date.getFullYear() + '年' + (date.getMonth() + 1) + '月' + date.getDate() + '日';
				}

				function fromEmptyToZero(noStr) {
					if(noStr == '' || noStr == undefined) {
						noStr = 0;
					}
					return noStr;
				}
			});

			function back() {
				location = 'ReportCenter.aspx';
			}
		</script>
	</body>

</html>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChildAttendance.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ChildAttendance" %>

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
				width: 25%;
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
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;幼儿考勤</h1>
		</ion-header-bar>
		<ion-content class='has-header' style='background-color: #E2EEF6;'>
			<ion-list style='padding-bottom: 10px;text-align: center;'>
				<label class="item item-input" style='height:45px;text-align: center;'>
				    <span class="input-label"></span>
				    <input type='date' ng-change='changeTime(inputTime)' ng-model='inputTime'/>
				</label>
				<ion-item style='text-align: center;padding-bottom: 37px;'>
					<label style='position: absolute;top:29%;left:39%;color:#7D899B;font-size: 55px;'>{{percent}}</label>
					<canvas id='myChart' wdith="200" height='200'></canvas>
					<span style='position:absolute;bottom:1%;left:33%;color:#9F9F9F;font-size:15px;font-weight: 500;'>
						幼儿出勤率<br />
	                    <span>({{showTime}})</span>
					</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item><span class='th'>班级</span><span class='th'>出勤人数</span><span class='th'>缺勤人数</span><span class='th'>出勤比例</span></ion-item>
				<ion-item ng-repeat='item in attendanceSituation'>
					<span class='td'>
						{{item.cClassName}}
					</span>
					<span class='td'>
						{{item.sTurn}}
					</span>
					<span class='td'>
						{{item.sAbsence}}
					</span>
					<span class='td'>
						{{item.attendanceRatio}}
					</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
			</ion-list>
		</ion-content>
		<script>
			var _date = getQueryStringValue('date');
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.sTurn = 0;
				$scope.sAbsence = 0;
				$scope.attendanceSituation = [];
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
					location = 'ChildAttendance.aspx?date=' + inputTime.getFullYear() + '-' + (inputTime.getMonth() + 1) + '-' + inputTime.getDate();
				}

				function initPage() {
					initTime();
					commonService.postData({
						url: 'DcCdReport',
						params: {
							Action: 'GetStatistics2',
							Type: 'S',
							dDate: $scope.inputTime.getFullYear()+'-'+($scope.inputTime.getMonth()+1)+'-'+$scope.inputTime.getDate()
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								angular.forEach(m_objData, function(value,key) {
									var sTurn = parseInt(value.iAttend);
									var sAbsence = parseInt(value.iTotal)+parseInt(value.iAttend);
									$scope.attendanceSituation.push({
										cClassName: value.cClassName,
										sTurn: sTurn,
										sAbsence: sAbsence,
										attendanceRatio: ((sTurn / (sTurn + sAbsence))*100).toFixed(0) + '%'
									});
									$scope.sTurn += sTurn;
									$scope.sAbsence += sAbsence;
								});
								loadChart($scope.sTurn, $scope.sAbsence);
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

				function loadChart(sTurn, sAbsence) {
					sTurn = fromEmptyToZero(sTurn);
					sAbsence = fromEmptyToZero(sAbsence);
					if((sTurn+sAbsence)!=0){
						var sTurnRatio = ((sTurn/(sTurn+sAbsence))*100).toFixed(0);
						var sAbsenceRatio = ((sAbsence/(sTurn+sAbsence))*100).toFixed(0);
					}else{
						var sTurnRatio = 0;
						var sAbsenceRatio = 100;
					}
					if(sTurnRatio==0&&sAbsenceRatio==0){
						var sTurnRatio = 0;
						var sAbsenceRatio = 100;
					}
					var ctx = document.getElementById('myChart').getContext('2d');
					var data = [{
						value: sTurnRatio,
						label: '出勤率',
						color: '#4FB0EF'
					}, {
						value: sAbsenceRatio,
						label: '缺勤率',
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
					$scope.percent = data[0].value+'%';
				}

				function formatDateToStr(date) {
					return date.getFullYear() + '年' + (date.getMonth() + 1) + '月' + date.getDate() + '日';
				}
				
				function fromEmptyToZero(noStr){
					if(noStr==''||noStr==undefined){
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
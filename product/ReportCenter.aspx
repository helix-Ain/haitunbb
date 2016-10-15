<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportCenter.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.ReportCenter" %>

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
			span.percent {
				font-size: 20px;
				font-weight: 500;
			}
			
			span.num {
				color: #F98D9D;
			}
			
			div.row {
				padding: 0;
			}
			
			div.col {
				padding: 3px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/teacher_title.png);background-size:cover;'>
			<h1 class='title' style='text-align: center;'>报表中心</h1>
		</ion-header-bar>
		<ion-content class='has-header' style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<ion-item style='padding-top:0;padding-bottom: 0;'>
					<div class='row'>
						<div class='col' style='text-align: center;'>
							<div class='row'>
								<div class='col' style='text-align: center;color:#99A0A9;'>今日幼儿考勤</div>
							</div>
							<div class='row' style='border-right: 1px solid #E8E8E8;'>
								<div class='col' style='text-align: center;'>
									<label style='position: absolute;top:33%;left:18%;color:#7D899B;font-size: 15px;'>出勤比例<br/><span class='percent'>{{percent1}}</span>%</label>
									<canvas id='myChart1' width='125'></canvas>
								</div>
							</div>
							<div class='row'>
								<div class='col' style='text-align: center;'>
									<span style='font-size:13px;'><span class='num'>{{sTurn}}</span>人出勤&nbsp;&nbsp;<span class='num'>{{sAbsence}}</span>人未出勤</span><br />
									<button style='background-color: transparent;border:1px solid #7CCCF7;border-radius: 3px; color:#7CCCF7;font-size:small;margin:5px 0' onclick='location="ChildAttendance.aspx"'>查看详情</button>
								</div>
							</div>
						</div>
						<div class='col' style='text-align: center;'>
							<div class='row'>
								<div class='col' style='text-align: center;color:#99A0A9;'>今日教师考勤</div>
							</div>
							<div class='row'>
								<div class='col' style='text-align: center;'>
									<label style='position: absolute;top:33%;right:18%;color:#7D899B;font-size: 15px;'>出勤比例<br/><span class='percent'>{{percent2}}</span>%</label>
									<canvas id='myChart2' width='125'></canvas>
								</div>
							</div>
							<div class='row'>
								<div class='col' style='text-align: center;'>
									<span style='font-size:13px;'><span class='num'>{{tTurn}}</span>人出勤&nbsp;&nbsp;<span class='num'>{{tAbsence}}</span>人未出勤</span><br />
									<button style='background-color: transparent;border:1px solid #7CCCF7;border-radius: 3px; color:#7CCCF7;font-size:small;margin:5px 0' onclick='location="TeacherAttendanceDaily.aspx"'>查看详情</button>
								</div>
							</div>
						</div>
					</div>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item style='padding:0;background-color:#E2EEF6;border:none;'>
					<div class='row' style='height:100px;padding:0;background-color:#E2EEF6;'>
						<div style='width:33%;margin-left:5px;background-image:url(Image/teacher_chenjian.png);background-size:cover;cursor:pointer;' onclick='location="ChildMorningCheck.aspx"'></div>
						<div ng-if='false' class='col' style='margin-right:5px;background-image:url(Image/teacher_chenjian.png);background-size:cover;cursor:pointer;' onclick='location="ChildMorningCheck.aspx"'></div>
						<div ng-if='false' class='col' style='margin-right:5px;background-image:url(Image/teacher_shizitj.png);background-size:cover;cursor:pointer;' onclick='location="TeacherStatisticsProgress.aspx"'></div>
						<div ng-if='false' class='col' style='background-image:url(Image/teacher_yrbgfx.png);background-size:cover;cursor:pointer;' onclick='location="BgAnalysisParentEdu.aspx"'></div>
					</div>
				</ion-item>
				<ion-item style='height:5px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item style='padding:0;background-color:#E2EEF6;border:none;'>
					<div class='row' style='height:100px;padding:0;background-color:#E2EEF6;'>
						<div ng-if='false' class='col' style='margin-right:5px;background-image:url(Image/teacher_yrqingjia.png);background-size:cover;cursor:pointer;' onclick='location="ChildLeave.aspx"'></div>
						<div ng-if='false' class='col' style='margin-right:5px;background-image:url(Image/teacher_ruliyuanfenxi.png);background-size:cover;cursor:pointer;' onclick='location="FlowAnalysisEnter.aspx"'></div>
						<div ng-if='fasle' class='col'></div>
					</div>
				</ion-item>
				<ion-item style='padding:0;background-color:#E2EEF6;border:none;'>
					<div class='row' style='height:50px;padding:0;background-color:#E2EEF6;'>
						<div class='col'></div>
					</div>
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

				function initPage() {
					var myDate = new Date();
					commonService.postData({
						url: 'DcCdReport',
						params: {
							Action: 'GetStatistics5',
							Type: 'S',
							dDate: myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate()
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var s_objData = ci_result.rows[0];
								commonService.postData({
									url: 'DcCdReport',
									params: {
										Action: 'GetStatistics5',
										Type: 'T',
										dDate: myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate()
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var t_objData = ci_result.rows[0];
											$scope.sTurn = s_objData.fAttend;
											$scope.sAbsence = s_objData.fAbsent;
											$scope.tTurn = t_objData.fAttend;
											$scope.tAbsence = t_objData.fAbsent;
											loadChart(s_objData.fAttend, s_objData.fAbsent, t_objData.fAttend, t_objData.fAbsent);
										} else {
											commonService.showAlert('查询数据为空！');
										}
									}
								});
							} else {
								commonService.showAlert('查询数据为空！');
							}
						}
					});
				}

				function loadChart(sTurn, sAbsence, tTurn, tAbsence) {
					sTurn = parseInt(fromEmptyToZero(sTurn));
					sAbsence = parseInt(fromEmptyToZero(sAbsence));
					tTurn = parseInt(fromEmptyToZero(tTurn));
					tAbsence = parseInt(fromEmptyToZero(tAbsence));
					if((sTurn + sAbsence) != 0) {
						var sTurnRatio = ((sTurn / (sTurn + sAbsence))*100).toFixed(0);
						var sAbsenceRatio = ((sAbsence / (sTurn + sAbsence))*100).toFixed(0);
					} else {
						var sTurnRatio = 0;
						var sAbsenceRatio = 100;
					}
					if((tTurn + tAbsence) != 0) {
						var tTurnRatio = ((tTurn / (tTurn + tAbsence))*100).toFixed(0);
						var tAbsenceRatio = ((tAbsence / (tTurn + tAbsence))*100).toFixed(0);
					} else {
						var tTurnRatio = 0;
						var tAbsenceRatio = 100;
					}
					if(sTurnRatio == 0 && sAbsenceRatio == 0) {
						var sTurnRatio = 0;
						var sAbsenceRatio = 100;
					}
					if(tTurnRatio == 0 && tAbsenceRatio == 0) {
						var tTurnRatio = 0;
						var tAbsenceRatio = 100;
					}
					var ctx1 = document.getElementById('myChart1').getContext('2d');
					var ctx2 = document.getElementById('myChart2').getContext('2d');
					var data1 = [{
						value: sTurnRatio,
						label: '幼儿出勤率',
						color: '#65C7D2'
					}, {
						value: sAbsenceRatio,
						label: '幼儿缺勤率',
						color: '#DEF0F9'
					}];
					var data2 = [{
						value: tTurnRatio,
						label: '教师出勤率',
						color: '#F98D9D'
					}, {
						value: tAbsenceRatio,
						label: '教师缺勤率',
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
					new Chart(ctx1).Doughnut(data1, options);
					new Chart(ctx2).Doughnut(data2, options);
					$scope.percent1 = data1[0].value;
					$scope.percent2 = data2[0].value;
				}

				function fromEmptyToZero(noStr) {
					if(noStr == '' || noStr == undefined) {
						noStr = 0;
					}
					return noStr;
				}
			});

			function back() {
				gotoApp();
			}
		</script>
	</body>

</html>
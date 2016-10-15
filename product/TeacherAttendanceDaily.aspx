<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeacherAttendanceDaily.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.TeacherAttendanceDaily" %>

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
			
			ion-item.item {
				padding-top: 12px;
				padding-bottom: 12px;
				text-align: center;
				font-size: 15px;
			}
			
			ion-item.item span:not(.num) {
				margin-right: 7px;
			}
			
			span.num {
				color: #CB8480;
			}
			
			span.th,
			span.td {
				width: 33%;
				text-align: center;
			}
			span.warn{
				color:#FF373F;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/teacher_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;教师考勤</h1>
		</ion-header-bar>
		<ion-tabs class="tabs-striped tabs-top tabs-background-light tabs-color-calm">
			<a class="tab-item" ng-class='{active:tab==1}' href='TeacherAttendanceDaily.aspx'>
				每日考勤
			</a>
			<a class="tab-item" ng-class='{active:tab==2}' href='TeacherAttendanceMonthly.aspx'>
				每月考勤
			</a>
		</ion-tabs>
		<ion-content class='has-tabs-top' style='background-color: #E2EEF6;'>
			<ion-list style='padding-bottom: 10px;'>
				<label class="item item-input" style='height:45px;text-align: center;'>
				    <span class="input-label"></span>
				    <input type='date' ng-change='changeTime(inputTime)' ng-model='inputTime'/>
				</label>
				<ion-item style='text-align: center;'>
					<span>共<span class='num'>{{iTotal}}</span>人</span>
					<span>到校<span class='num'>{{tTurn}}</span></span>
					<span>缺席<span class='num'>{{tAbsence}}</span></span>
					<span>请假<span class='num'>{{iLeave}}</span></span>
					<span>迟到<span class='num'>{{iLate}}</span></span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item><span class='th'>姓名</span><span class='th'>上午</span><span class='th'>下午</span></ion-item>
				<ion-item ng-repeat='item in attendanceSituation'>
					<span class='td'>
						{{item.cUserChiName}}
					</span>
					<span class='td'>
						<span ng-if='item.cAMStatusDesc!="缺席"'>{{item.cAMStatusDesc}}</span>
						<span ng-if='item.cAMStatusDesc=="缺席"' class='warn'>{{item.cAMStatusDesc}}</span>
					</span>
					<span class='td'>
						<span ng-if='item.cPMStatusDesc!="缺席"'>{{item.cPMStatusDesc}}</span>
						<span ng-if='item.cPMStatusDesc=="缺席"' class='warn'>{{item.cPMStatusDesc}}</span>
					</span>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
			</ion-list>
		</ion-content>
		<script>
			var _date = getQueryStringValue('date');
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.tab = 1;
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
				
				$scope.changeTime = function(inputTime){
					location = 'TeacherAttendanceDaily.aspx?date='+inputTime.getFullYear()+'-'+(inputTime.getMonth()+1)+'-'+inputTime.getDate();
				}

				function initPage() {
					initTime();
					commonService.postData({
						url: 'DcCdReport',
						params: {
							Action: 'GetStatistics2',
							Type: 'T',
							dDate: $scope.inputTime.getFullYear()+'-'+($scope.inputTime.getMonth()+1)+'-'+$scope.inputTime.getDate()
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.iTotal = parseInt(m_objData.iTotal);
								$scope.iAttend = parseInt(m_objData.iAttend);
								$scope.iSkip = parseInt(m_objData.iSkip);
								$scope.iLeave = parseInt(m_objData.iLeave);
								$scope.iLate = parseInt(m_objData.iLate);
								$scope.iVacation = parseInt(m_objData.iVacation);
								$scope.tTurn = $scope.iAttend;
								$scope.tAbsence = $scope.iTotal - $scope.iAttend;
								commonService.postData({
									url: 'DcCdReport',
									params: {
										Action: 'GetAttendanceDetail',
										Type: 'T',
										dDate: $scope.inputTime.getFullYear()+'-'+($scope.inputTime.getMonth()+1)+'-'+$scope.inputTime.getDate()
									},
									success: function(ci_result) {
										if(existData(ci_result)) {
											var m_objData = ci_result.rows;
											angular.forEach(m_objData, function(value, key) {
												$scope.attendanceSituation.push({
													cUserChiName: value.cUserChiName,
													cAMStatusDesc: value.cAMStatusDesc,
													cPMStatusDesc: value.cPMStatusDesc
												});
											});
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

				function initTime() {
					if(_date != undefined && _date != '') {
						var myDate = new Date(_date);
					} else {
						var myDate = new Date();
					}
					$scope.inputTime = myDate;
				}
			});

			function back() {
				location = 'ReportCenter.aspx';
			}
		</script>
	</body>

</html>
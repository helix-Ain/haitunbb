<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MorningCheckRecord.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.MorningCheckRecord" %>

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
		<style>
			div.col {
				text-align: center;
				height: 50px;
				padding: 2px;
				line-height: 25px;
				margin: 1px;
			}
			
			div.week {
				background-color: #E4EFF5;
				height: 35px;
				color: #839EAA;
			}
			
			div.current-month {
				background-color: #FFFFFF;
				color: #838383;
			}
			
			div.current-month:hover {
				background-color: #01C3FF;
				color: #FFFFFF;
			}
			
			div.not-current-month {
				background-color: #E4EFF5;
				color: #B8C1C6;
			}
			
			div.current-date {
				background-color: #01C3FF;
				color: #FFFFFF;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;晨检记录</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<ion-item style='text-align: center;'>
					<div class='icon ion-ios-arrow-left' style='cursor:pointer;display: inline-block;height:100%;width:55px;' ng-click='previous()'></div>
					<span style='margin:0 15px;'><span>{{_date}}</span></span>
					<div class='icon ion-ios-arrow-right' style='cursor:pointer;display: inline-block;height:100%;width:55px;' ng-click='next()'></div>
				</ion-item>
				<ion-item style='background-color:#E4EFF5;padding-bottom: 0;padding-top:0;'>
					<div class='row'>
						<div class='col week'>日</div>
						<div class='col week'>一</div>
						<div class='col week'>二</div>
						<div class='col week'>三</div>
						<div class='col week'>四</div>
						<div class='col week'>五</div>
						<div class='col week'>六</div>
					</div>
					<div class='row' ng-repeat='index in calendarRowsCount'>
						<div ng-class='item.nClass' ng-repeat='item in calendar[index]' ng-click='detail(item.no,item.nClass[1]);'>{{item.no}}<br/><img ng-if='checked[item.no] == true && item.nClass[1] == "current-month"' src="/CI/Mobile/Image/health_gouxuan2.png" style='width:20px;height:20px;' /><img ng-if='abnormal[item.no] == true && item.nClass[1] == "current-month"' src="/CI/Mobile/Image/health_abnormal.png" style='width:20px;height:20px;' /></div>
					</div>
					<div class='row'>
						<div class='col' style='background-color: #E4EFF5;height:25px;'></div>
					</div>
				</ion-item>
				<ion-item>
					<span style='width:33%;display: inline-block;text-align: center;color:#44D194;'>日期</span><span style='width:33%;display: inline-block;text-align: center;color:#D67372;'>体温</span><span style='width:33%;display: inline-block;text-align: center;color:#5CD9F2;'>晨检</span>
				</ion-item>
				<ion-item>
					<span style='width:33%;display:inline-block;text-align: center;'><span style='font-size: 15px;'>{{day}}</span><br/><span style='font-size: 15px;'>{{week}}</span></span><span style='width:33%;display: inline-block;text-align: center;'>{{cBbtStatusDesc}}</span><span style='width:33%;display: inline-block;text-align: center;'>{{cSympStatusDesc}}</span>
				</ion-item>
			</ion-list>
		</ion-content>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.calendar = [];
				$scope.checked = [];
				$scope.abnormal = [];
				$scope._date = getQueryStringValue('date');
				$scope.calendarRowsCount = [0, 1, 2, 3, 4, 5];
				$scope.detail = function(no, flag) {
					if(flag == 'current-month') {
						var _date = $scope._date + '-' + no;
						$window.location = 'MorningCheckDetail.aspx?date=' + _date;
					} else {
						return;
					}

				}
				$scope.init = function() {
					initService.initReady($scope, function() {
						commonService.checkPagePower({
							onload: function() {
								initPage();
							}
						});
					});
				}
				$scope.previous = function() {
					commonService.showMask();
					var day = new Date($scope._date);
					var myDate = new Date(day.getFullYear(), day.getMonth() - 1);
					$scope._date = myDate.getFullYear() + '-' + (myDate.getMonth() + 1);
					showCalendar($scope._date);
					commonService.hideMask();
				}

				$scope.next = function() {
					commonService.showMask();
					var day = new Date($scope._date);
					var myDate = new Date(day.getFullYear(), day.getMonth() + 1);
					$scope._date = myDate.getFullYear() + '-' + (myDate.getMonth() + 1);
					showCalendar($scope._date);
					commonService.hideMask();
				}

				function initPage() {
					var myDate = new Date();
					if($scope._date == undefined || $scope._date == '') {
						$scope._date = myDate.getFullYear() + '-' + (myDate.getMonth() + 1);
					}
					$scope.day = myDate.getDate();
					$scope.week = getWeek(myDate.getDay());
					commonService.postData({
						url: 'DcCdHealthCheckManage',
						params: {
							Action: 'GetList',
							Type: 'U',
							IsToday: true
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.cBbtStatusDesc = m_objData.cBbtStatusDesc;
								$scope.cSympStatusDesc = m_objData.cSympStatusDesc;
							} else {
								$scope.cBbtStatusDesc = '未检';
								$scope.cSympStatusDesc = '未检';
							}
						}
					});
					if($scope._date != undefined && $scope._date != '') {
						var cDate = new Date($scope._date);
						showCalendar(cDate.getFullYear() + '-' + (cDate.getMonth() + 1));
					} else {
						showCalendar();
					}

				}

				function showCalendar(_date) {
					$scope.checked = [];
					if(_date == undefined || _date == '') {
						_date = new Date();
					}
					for(var i = 0; i < 6; i++) {
						$scope.calendar[i] = [];
					}
					var currDate = new Date(_date);
					var lastDate = new Date(currDate.getFullYear(), currDate.getMonth() - 1, currDate.getDate());
					if(currDate.getFullYear() == new Date().getFullYear() && currDate.getMonth() == new Date().getMonth()) {
						var currDay = $scope.day;
					} else {
						var currDay = null;
					}
					var week = new Date(currDate.getFullYear(), currDate.getMonth(), 0).getDay();
					var shifting = week % 7;
					var lastMonthCountDays = getCountDays(lastDate);
					var currMonthCountDays = getCountDays(currDate);
					for(var i = shifting, j = 0; i >= 0 || j < 7; i--, j++) {
						if(i >= 0) {
							$scope.calendar[0].push({
								no: lastMonthCountDays - i,
								nClass: ['col', 'not-current-month']
							});
						} else {
							var no = j - shifting;
							if(no != currDay) {
								$scope.calendar[0].push({
									no: no,
									nClass: ['col', 'current-month']
								});
							} else {
								$scope.calendar[0].push({
									no: no,
									nClass: ['col', 'current-month', 'current-date']
								});
							}

						}
					}
					if($scope.calendar[0][6].nClass[1] == 'not-current-month') {
						for(var i = 0, j = $scope.calendar[0][6].no + 1; i < 7; i++, j++) {
							if(j > lastMonthCountDays) {
								var no = j - lastMonthCountDays;
								if(no != currDay) {
									$scope.calendar[1].push({
										no: no,
										nClass: ['col', 'current-month']
									});
								} else {
									$scope.calendar[1].push({
										no: no,
										nClass: ['col', 'current-month', 'current-date']
									});
								}

							} else {
								$scope.calendar[1].push({
									no: j,
									nClass: ['col', 'not-current-month']
								});
							}

						}
					} else {
						for(var i = 0, j = $scope.calendar[0][6].no + 1; i < 7; i++, j++) {
							var no = j;
							if(no != currDay) {
								$scope.calendar[1].push({
									no: no,
									nClass: ['col', 'current-month']
								});
							} else {
								$scope.calendar[1].push({
									no: no,
									nClass: ['col', 'current-month', 'current-date']
								});
							}

						}
					}

					for(var i = 0, j = $scope.calendar[1][6].no + 1; i < 7; i++, j++) {
						var no = j;
						if(no != currDay) {
							$scope.calendar[2].push({
								no: no,
								nClass: ['col', 'current-month']
							});
						} else {
							$scope.calendar[2].push({
								no: no,
								nClass: ['col', 'current-month', 'current-date']
							});
						}

					}
					for(var i = 0, j = $scope.calendar[2][6].no + 1; i < 7; i++, j++) {
						var no = j;
						if(no != currDay) {
							$scope.calendar[3].push({
								no: no,
								nClass: ['col', 'current-month']
							});
						} else {
							$scope.calendar[3].push({
								no: no,
								nClass: ['col', 'current-month', 'current-date']
							});
						}

					}
					for(var i = 0, j = $scope.calendar[3][6].no + 1; i < 7; i++, j++) {
						if(j <= currMonthCountDays) {
							var no = j;
							if(no != currDay) {
								$scope.calendar[4].push({
									no: no,
									nClass: ['col', 'current-month']
								});
							} else {
								$scope.calendar[4].push({
									no: no,
									nClass: ['col', 'current-month', 'current-date']
								});
							}

						} else {
							$scope.calendar[4].push({
								no: j - currMonthCountDays,
								nClass: ['col', 'not-current-month']
							});
						}
					}

					if($scope.calendar[4][6].nClass[1] == 'current-month' && $scope.calendar[4][6].no != currMonthCountDays) {
						for(var i = 0, j = $scope.calendar[4][6].no + 1; i < 7; i++, j++) {
							if(j <= currMonthCountDays) {
								var no = j;
								if(no != currDay) {
									$scope.calendar[5].push({
										no: no,
										nClass: ['col', 'current-month']
									});
								} else {
									$scope.calendar[5].push({
										no: no,
										nClass: ['col', 'current-month', 'current-date']
									});
								}

							} else {
								$scope.calendar[5].push({
									no: j - currMonthCountDays,
									nClass: ['col', 'not-current-month']
								});
							}
						}
					}
					commonService.postData({
						url: 'DcCdHealthCheckManage',
						params: {
							Action: 'GetList',
							Type: 'U',
							StartDate: new Date(currDate.getFullYear(), currDate.getMonth(), 1).toLocaleDateString(),
							EndDate: new Date(currDate.getFullYear(), currDate.getMonth(), currMonthCountDays).toLocaleDateString()
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows;
								angular.forEach(m_objData, function(value, key) {
									if(value.cBbtStatusDesc != '未检' || value.cSympStatusDesc != '未检') {
										if(value.cBbtStatusDesc != '异常' && value.cSympStatusDesc != '异常') {
											var myDate = new Date(value.dDate);
											$scope.checked[myDate.getDate()] = true;
										}else{
										    var myDate = new Date(value.dDate);
										    $scope.abnormal[myDate.getDate()] = true;
										}
									}
								});
							}
						}
					});
				}

				function getWeek(i) {
					var weekday = new Array(7)
					weekday[0] = "周日";
					weekday[1] = "周一";
					weekday[2] = "周二";
					weekday[3] = "周三";
					weekday[4] = "周四";
					weekday[5] = "周五";
					weekday[6] = "周六";
					return weekday[i];
				}

				function getCountDays(_date) {
					var curDate = new Date(_date);
					var curMonth = curDate.getMonth();
					curDate.setMonth(curMonth + 1);
					curDate.setDate(0);
					return curDate.getDate();
				}
			});

			function back() {
				location = 'HealthCenter.aspx';
			}
		</script>
	</body>

</html>
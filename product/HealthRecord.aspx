<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HealthRecord.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.HealthRecord" %>

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
			div.history-title {
				font-size: 17px;
				float: left;
			}
			
			span.history-tag {
				white-space: normal;
				color: #A5A5A5;
				font-size: 14px;
				line-height: 17px;
			}
			
			i.ion-ios-arrow-right {
				color: #C1C1C1;
				font-size: 25px;
				margin-right: -10px;
			}
			
			#avatar {
				width: 55px;
				height: 55px;
				border-radius: 27.5px;
				display: inline-block;
				position: relative;
				top: -5px;
			}
		</style>
	</head>

	<body ng-controller='app' ng-init='init()' ng-cloak>
		<ion-header-bar class='bar-calm' style='background-color: #009BE8;background-image:url(Image/health_title.png);background-size:cover;'>
			<button class='button button-icon icon ion-ios-arrow-left' onclick="back()">返回</button>
			<h1 class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;健康记录</h1>
		</ion-header-bar>
		<ion-content style='background-color: #E2EEF6;padding-bottom: 15px;'>
			<ion-list>
				<ion-item>
					<img id='avatar' src="{{avatar}}" onerror="javascript:this.src='/CI/Mobile/Image/health_defaultavatar.png';" />
					<h6 style='color:#B7B7B7;font-size:15px;display: inline-block;'>
						<div>
							<div class='row' style='font-size:14px;'>
								<div class='col col-40'>
									姓名:&nbsp;<span style='display:inline-block;'>{{cUserChiName}}</span>
								</div>
								<div class='col col-120'>
									&nbsp;&nbsp;&nbsp;&nbsp;性别:&nbsp;<span style='display: inline-block;'>{{cSexDesc}}</span>
								</div>
							</div>
							<div class='row' style='font-size:14px;'>
								<div class='col col-40'>
									班级:&nbsp;<span style='display: inline-block;'>{{cClassName}}</span>
								</div>
								<div class='col col-120'>
									&nbsp;&nbsp;&nbsp;&nbsp;生日:&nbsp;<span style='display: inline-block;font-weight: 400;'>{{cBirthday}}</span>
								</div>
							</div>
						</div>
					</h6>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item class='item-icon-right' style='cursor:pointer;' onclick='location="AllergicHistory.aspx"'>
					<div class='history-title' style='color:#DC6C6F;'>&nbsp;&nbsp;&nbsp;&nbsp;过敏史：</div>
					<span class='history-tag'>{{cAllergyDesc}}</span>
					<i class="icon ion-ios-arrow-right"></i>
				</ion-item>
				<ion-item class='item-icon-right' style='cursor:pointer;' onclick='location="SyntrophusHistory.aspx"'>
					<div class='history-title' style='color:#47B787;'>遗传病史：</div>
					<div>
						<span class='history-tag'>{{cHeredityDesc}}</span>
					</div>
					<i class="icon ion-ios-arrow-right"></i>
				</ion-item>
				<ion-item style='height:12px;padding: 0;background-color: #E2EEF6;border:none;'></ion-item>
				<ion-item class='item-icon-right' style='padding:7px;cursor:pointer;' onclick='location="Vaccineinoculation.aspx"'>
					<img src="/CI/Mobile/Image/health_yimiao.png" style='width:50px;height:50px;float:left;margin-right:10px;' />
					<label style='font-size:15px;'>育苗接种</label><br /><span style='font-size:13px;color:#BCBCBC;display: block;margin-top:5px;'>记录孩子的疫苗接种情况</span>
					<i class="icon ion-ios-arrow-right"></i>
				</ion-item>
			</ion-list>
		</ion-content>
		<script>
			app.controller('app', function($scope, $window, commonService, initService) {
				$scope.init = function() {
					$scope.avatar = '/CI/Mobile/Image/health_defaultavatar.png';
					$scope.cClassName = '';
					$scope.cSexDesc = '';
					$scope.cUserChiName = '';
					$scope.cBirthday = '';
					$scope.cAllergyDesc = '';
					$scope.cHeredityDesc = '';
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
						url: 'DcCdUserManageEx',
						params: {
							Action: 'GetList',
							Type: 'U'
						},
						success: function(ci_result) {
							if(existData(ci_result)) {
								var m_objData = ci_result.rows[0];
								$scope.iUserID = m_objData.iUserID;
								$scope.avatar = m_objData.cPhotoUrl + m_objData.cPhotoFileName;
								$scope.cClassName = m_objData.cClassName;
								$scope.cSexDesc = m_objData.cSexDesc;
								$scope.cUserChiName = m_objData.cUserChiName;
								if(m_objData.cBirthday != '') {
									$scope.cBirthday = m_objData.cBirthday;
								} else {
									$scope.cBirthday = '未填写';
									$scope.data = {
										inputBirthday: ''
									};
									commonService.showPopup({
										template: '<input type="date" ng-model="data.inputBirthday"/>',
										title: '请完善生日信息',
										buttons: [{
											text: '保存',
											type: 'button-positive',
											onTap: function(e) {
												if($scope.data.inputBirthday != '') {
													var cBirthday = $scope.data.inputBirthday.getFullYear() + '-' + ($scope.data.inputBirthday.getMonth() + 1) + '-' + $scope.data.inputBirthday.getDate();
													commonService.postData({
														url: 'DcCdUserManageEx',
														params: {
															Action: 'Update',
															cBirthday: cBirthday,
															iUserID: $scope.iUserID
														},
														success: function(ci_result) {
															if(ci_result.DcCode == 0) {
																$scope.cBirthday = cBirthday;
																commonService.showAlert('保存成功');
															} else {
																commonService.showAlert(ci_result.DcMessage);
															}
														}
													});
												} else {
													e.preventDefault();
													commonService.showAlert('请完善生日信息');
												}
											}
										}]
									});
								}

							} else {
								commonService.showAlert('记录不存在或已删除');
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
								if(m_objData.cAllergyDesc != '' && m_objData.cOtherAllergy != '') {
									$scope.cAllergyDesc = m_objData.cAllergyDesc + ';' + m_objData.cOtherAllergy;
								} else if(m_objData.cAllergyDesc != '') {
									$scope.cAllergyDesc = m_objData.cAllergyDesc;
								} else if(m_objData.cOtherAllergy != '') {
									$scope.cAllergyDesc = m_objData.cOtherAllergy;
								} else {
									$scope.cAllergyDesc = '无';
								}
								if(m_objData.cHeredityDesc != '' && m_objData.cOtherHeredity != '') {
									$scope.cHeredityDesc = m_objData.cHeredityDesc + ';' + m_objData.cOtherHeredity;
								} else if(m_objData.cHeredityDesc != '') {
									$scope.cHeredityDesc = m_objData.cHeredityDesc;
								} else if(m_objData.cOtherHeredity != '') {
									$scope.cHeredityDesc = m_objData.cOtherHeredity;
								} else {
									$scope.cHeredityDesc = '无';
								}
							} else {
								commonService.showAlert('记录不存在或已删除');
							}
						}
					});
				}
			});

			function back() {
				location = 'HealthCenter.aspx';
			}
		</script>
	</body>

</html>
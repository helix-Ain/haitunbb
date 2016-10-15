<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NoticeList.aspx.cs" Inherits="Digicloud.DAM.Web.CI.Mobile.NoticeList" EnableViewState="false" %>

<!DOCTYPE html>
<html>
<head>
    <title>宝宝366</title>	
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />    
    <link rel="stylesheet" href="../../JS/JQueryMobile/haitunbb.css" />
    <link rel="stylesheet" href="../../JS/JQueryMobile/jquery.mobile.min.css" />
    <link rel="stylesheet" href="../../JS/JQueryMobile/jquery.mobile.icons.min.css" />
    <link rel="stylesheet" href="../../JS/JQueryMobile/iscroll-push.css" />
	<script src="../../JS/JQueryMobile/jquery.min.js"></script>
	<script src="../../JS/JQueryMobile/jquery.mobile.min.js"></script>
	<script src="JS/Constants.js"></script>
	<script src="../../JS/CommMobileScript.js"></script>
	<script src="../../JS/JQueryMobile/iscroll-probe.js"></script>
	<script src="../../JS/JQueryMobile/iscroll-push.js"></script>	
</head>
<body>
    <div data-role="page" data-theme="d" id="page_List">
        <div data-role="header">公告通知</div>
        <div data-role="content" data-theme="a" id="div_List">
        </div>
    </div>
    
    <div data-role="page" data-theme="d" id="page_Detail">  
        <div data-role="header">
            <a class= "ui-btn-left" href="#page_List" data-theme="d" style="margin-top:5px">返回</a>
            <div id="div_Title" style="max-width: 220px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; margin-left:60px;"></div>
        </div>  
        <div data-role="content" style="position:relative">
            <span id="div_Content"></span>
        </div>
    </div>
</body>
</html>
<script type="text/javascript">
    var _IScrollPush;
    var _CurPage = 1;

    window.onload = function() {
        _IScrollPush = new IScrollPush($("#div_List"), {
            pullUpEvent: function() { setData(); }
        });
    }

    checkPagePower({ onload: function() { initPage(); } });

    function initPage() {
        setData();
    }

    function setDetail(id) {
        postData({
            url: "DcCdNoticeManage",
            params: { Action: 'GetAllList', iNoticeID: id },
            success: function(result) {
                if (result.rows.length > 0) {
                    var row = result.rows[0];
                    $("#div_Title").html(row.cTitle);
                    $("#div_Content").html(row.cContent.replace(/&lt;/g, "<").replace(/&gt;/g, ">"));
                    $.mobile.changePage("#page_Detail");
                }
            }
        });
    }

    function setData() {
        postData({
            url: "DcCdNoticeManage",
            params: { Action: 'GetAllList', Type: 'S', page: _CurPage, rows: 20, sort: 'dCreationDt', order: 'desc' },
            success: function(result) {
                if (result.rows.length > 0) {
                    _CurPage++;
                    for (var i = 0; i < result.rows.length; i++) {
                        var row = result.rows[i];
                        _IScrollPush.setItem('<a href="#" onclick="setDetail(' + row.iNoticeID + ');">' + row.cTitle + '</a>');
                    }
                    _IScrollPush.refresh();
                    $("div[data-role=content] ul").listview('refresh');
                }
                else if (_CurPage > 0) {
                    alert('已经是最后一页');
                }
            }
        });
    }
</script>

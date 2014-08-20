<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="row">
	<h4>구매정보 입력 
		<button class="btn btn-info btn-xs" data-toggle="modal" data-target="#helpModal">도움말</button>
	</h4>
	
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
        <span aria-hidden="true"></span><span class="sr-only">Close</span></button>
        <h4 class="modal-title" id="myModalLabel">구매정보 입력</h4>
      </div>
      <div class="modal-body">
<ul>
	<li>결제통화 단위를 선택 후, 실제로 결제한 금액을 입력합니다.<br/>
		(물건금액+현지배송비+현지세금, 적립금 또는 기프트카드를 사용하였을 경우 해당금액포함.)
	</li>
	<li>무게 단위를 선택 후, 예상되거나 실측된 무게를 입력합니다.</li>
	<li>회원등급을 선택하지 않으시면 가장낮은 회원등급으로 계산됩니다.</li>
	<li>회원등급 옆칸에는 쿠폰 할인율을 입력하시고, 없을 경우 입력하지 않으셔도 됩니다.</li>
</ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

</div>

export const ticketReceiptTemplate = (cardName, price, duration) => `
<div style="font-family: 'Arial', sans-serif; color: #333;">
  <h2>მადლობა შენაძენისთვის!</h2>
  <p>ძვირფასო მომხმარებელო,</p>
  <p>ბილეთის შეძენა, წარმატებით განხორციელდა. აქ არის თქვენი ტრანზაქციის დეტალები:</p>
  <ul>
    <li>ბილეთის ტიპი: <strong>${cardName}</strong></li>
    <li>ფასი: <strong>₾${price.toFixed(2)}</strong></li>
    <li>მოქმედების ვადა: <strong>${duration}</strong></li>
  </ul>
  <p>თქვენი ბილეთი, მზადაა გამოსაყენებლად და იმოქმედებს მითითებული ვადით. ქვემოთ თან ერთვის თქვენი ავტობუსის ბილეთის QR კოდი. ავტობუსში ასვლისას, წარმოადგინეთ QR კოდი.</p>
  <img src="cid:qrcode" alt="Bus Ticket QR Code" style="margin-top: 20px; max-width: 200px;"/>
  <p>მადლობა, რომ ირჩევთ ჩვენს სერვისს. გისურვებთ ბედნიერ მგზავრობას!</p>
  <p><strong>Bussify team</strong></p>
</div>
`
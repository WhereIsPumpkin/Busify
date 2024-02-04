export const validTicketTemplate = (
  passengerName,
  ticketDuration,
  ticketPrice,
  purchaseDate
) => {
  const names = passengerName.split(" ")
  const formattedFirstName = capitalizeFirstLetter(names[0])
  const formattedLastName = capitalizeFirstLetter(names.slice(1).join(" "))

  return ` 
  <!DOCTYPE html>
  <html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f0f0f0;
        color: #333;
      }
      .container {
        max-width: 600px;
        margin: auto;
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      }
      .header {
        background-color: #00ADB5;
        color: #fff;
        padding: 10px 20px;
        text-align: center;
      }
      .content {
        padding: 20px;
      }
      .content p {
        margin: 10px 0;
        font-size: 16px;
      }
      .bold {
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <h1>ბილეთი ვალიდურია</h1>
      </div>
      <div class="content">
      <p><span class="bold">მგზავრის სახელი:</span> ${formattedFirstName} ${formattedLastName}</p>
        <p><span class="bold">ბილეთის ვადა:</span> ${ticketDuration}</p>
        <p><span class="bold">ფასი:</span> ${ticketPrice}</p>
        <p><span class="bold">ყიდვის დრო:</span> ${purchaseDate}</p>
      </div>
    </div>
  </body>
  </html>
  `
}

const capitalizeFirstLetter = (str) => {
  return str.replace(/\b\w/g, (char) => char.toUpperCase())
}

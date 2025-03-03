CREATE TABLE URL (
	origin_link VARCHAR(255),
  short_link VARCHAR(255),
  author VARCHAR(255),
  created_date DATETIME,
  end_date DATETIME
)
CREATE TABLE Users (
    UserId INT,  -- INT không cần chỉ định độ dài
    UserName VARCHAR(255),  -- VARCHAR không thể có độ dài âm, đặt một giá trị hợp lý như 255
    Password VARCHAR(255),  
    Email VARCHAR(255)
);

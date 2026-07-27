# ⌨️ Neovim Keybindings Layout for Rofi Popup

[Clipboard]   Ctrl + c           |    Sao chép (Yank) dòng hoặc khối chọn vào clipboard hệ thống
[Clipboard]   Leader + y         |    Sao chép nhiều dòng tùy chọn (Nhập dòng Bắt đầu & Kết thúc)
[Clipboard]   Ctrl + x           |    Cắt (Delete) dòng hoặc khối chọn vào clipboard hệ thống
[Clipboard]   Ctrl + v           |    Dán (Paste) từ bộ nhớ hệ thống vào sau con trỏ
[Clipboard]   Ctrl + a           | 📑 Chọn tất cả văn bản trong file hiện tại (Select All)
[Delete Ops]  d g g              | ✂️ Xóa từ dòng hiện tại ngược lên ĐẦU file (g: go to top)
[Delete Ops]  d G                | ✂️ Xóa từ dòng hiện tại xuôi xuống CUỐI file (G: go to bottom)
[Delete Ops]  :1,X d             | ✂️ Xóa một phạm vi cố định từ dòng 1 đến dòng X (Nhập lệnh)
[Delete Ops]  :X,Y d             | ✂️ Xóa một phạm vi cố định từ dòng X đến dòng Y (Nhập lệnh)
[Delete Ops]  X d d              | ✂️ Xóa một số lượng X dòng cố định tính từ dòng hiện tại


[Search/FZF]  Ctrl + p           | 🔍 FZF: Tìm kiếm tên tệp nhanh (Find Files)
[Search/FZF]  Ctrl + f           | 🔍 FZF: Tìm chữ trong file hiện tại (Current Buffer)
[Search/FZF]  Leader + f g       | 🔍 FZF: Tìm chữ real-time trong dự án (Live Grep)
[Search/FZF]  Leader + s f       | 🔍 FZF: Tìm chữ bao gồm cả file ẩn (Hidden Files)
[Search/FZF]  Leader + f s       | 🔍 FZF: Nhập từ khóa để tìm chữ trong dự án (Grep with input)
[Search/FZF]  Leader + f r       | 🕒 FZF: Mở danh sách các tệp đã đọc gần đây (Recent Files)
[Search/FZF]  Leader + f h       | ❓ FZF: Tra cứu tài liệu hướng dẫn Neovim (Help Tags)
[Search/FZF]  Leader + f b       | 🗂️ FZF: Danh sách các tab đang mở (Buffers menu)
[Search/Sub]  Ctrl + h           | 🪄 Tìm và Thay thế (Find & Replace) qua hộp thoại Prompt

[LSP/Code]    g d                | 🧠 Đi đến nơi định nghĩa hàm/biến (Go to Definition)
[LSP/Code]    g r                | 🧠 Tìm tất cả những nơi sử dụng hàm/biến này (References)
[LSP/Code]    K                  | 💡 Hiện tài liệu hướng dẫn/kiểu dữ liệu của từ dưới con trỏ (Hover)
[LSP/Code]    Leader + c a       | 💡 Hiện các gợi ý sửa lỗi code nhanh (Code Action)
[LSP/Code]    Leader + r n       | ✏️ Đổi tên biến/hàm trên toàn bộ dự án (Rename)
[LSP/Code]    Leader + c f       | 🧼 Định dạng lại toàn bộ mã nguồn (Format Code)
[LSP/Code]    ] d / [ d          | 🚨 Nhảy nhanh đến lỗi/cảnh báo tiếp theo / phía trước

[Git Ops]     Leader + g b       | 📜 Xem ai là người viết dòng code này (Git Blame)
[Git Ops]     Leader + g d       | 📜 Xem các thay đổi so với bản Git cũ (Git Diff)
[Git Ops]     ] g / [ g          | 🔀 Nhảy nhanh đến đoạn code vừa sửa tiếp theo / phía trước
[Git Ops]     Leader + g r       | ↩️ Khôi phục đoạn code vừa sửa về nguyên bản (Reset Hunk)
[Git Ops]     Leader + g p       | 👁️ Xem nhanh nội dung thay đổi của dòng đó (Preview Hunk)

[File Tree]   Leader + e         | 🌲 Bật/Ẩn thanh quản lý thư mục (Toggle Neo-tree/NvimTree)
[File Tree]   Leader + o f       | 🌲 Tìm và định vị file hiện tại trên cây thư mục (Focus Tree)

[Comments]    gcc                | 💬 Bật/Tắt ghi chú (Comment) cho dòng hiện tại
[Comments]    gc (Visual)        | 💬 Bật/Tắt ghi chú (Comment) cho cả khối đang chọn

[Macro/Rep]   qX                 | 📼 Bắt đầu ghi lại chuỗi hành động vào phím X (Ghi Macro)
[Macro/Rep]   q                  | 📼 Dừng ghi chuỗi hành động (Stop Macro)
[Macro/Rep]   @X                 | 📼 Thực thi chuỗi hành động đã ghi ở phím X
[Macro/Rep]   .                  | 🔄 Lặp lại hành động chỉnh sửa vừa thực hiện trước đó

[Surround]    y s i w "          | 📦 Bọc từ hiện tại vào trong dấu ngoặc kép ""
[Surround]    c s " '            | 📦 Đổi dấu bọc ngoài từ dấu "" sang dấu ''
[Surround]    d s "              | 📦 Xóa dấu bọc ngoài "" của từ hiện tại


[Run & Term]  F6                 |    Thực thi nhanh tệp tin hiện tại (Python, JS, Go, C,...)
[Run & Term]  Leader + t (Normal)| 💻 Bật/Ẩn cửa sổ Terminal nổi (Toggle Terminal Float)
[Run & Term]  Leader + t (Term)  | 💻 Ẩn cửa sổ Terminal khi đang ở trong chế độ Terminal
[Run & Term]  Esc (Term mode)    | 🚪 Thoát nhanh chế độ nhập liệu Terminal (về Normal)
[Run & Term]  Leader + q (Term)  | ❌ Đóng và xóa hoàn toàn Buffer của Terminal hiện tại

[File Ops]    Ctrl + s           | 💾 Lưu file nhanh (Hoạt động ở mọi chế độ i, x, n, s)
[File Ops]    Leader + q q       | ❌ Lưu tất cả, đóng toàn bộ và thoát Neovim

[Navigation]  j / k / Mũi tên     | 🪜 Di chuyển mượt theo dòng hiển thị (visual line)
[Navigation]  Ctrl + h           | 🪟 Chuyển sang cửa sổ (split) bên Trái
[Navigation]  Ctrl + j           | 🪟 Chuyển sang cửa sổ (split) bên Dưới
[Navigation]  Ctrl + k           | 🪟 Chuyển sang cửa sổ (split) bên Trên
[Navigation]  Ctrl + l           | 🪟 Chuyển sang cửa sổ (split) bên Phải

[Splits]      Leader + o         | 🧱 Chia đôi màn hình theo chiều Dọc (vsplit)
[Splits]      Leader + p         | 🧱 Chia đôi màn hình theo chiều Ngang (split)
[Splits]      Leader + c         | 🚪 Đóng cửa sổ (split) hiện tại
[Splits]      Leader + co        | 🚪 Đóng tất cả các cửa sổ khác, giữ lại cửa sổ này

[Resize]      Ctrl + Mũi tên Lên  | 📐 Tăng chiều cao cửa sổ (+2)
[Resize]      Ctrl + Mũi tên Xuống | 📐 Giảm chiều cao cửa sổ (-2)
[Resize]      Ctrl + Mũi tên Trái | 📐 Giảm chiều rộng cửa sổ (-2)
[Resize]      Ctrl + Mũi tên Phải | 📐 Tăng chiều rộng cửa sổ (+2)

[Buffers]     Shift + h / [ b    | 🗂️ Chuyển về Buffer (tab) phía trước
[Buffers]     Shift + l / ] b    | 🗂️ Chuyển đến Buffer (tab) tiếp theo
[Buffers]     Leader + b b / `   | 🔄 Chuyển đổi nhanh qua lại giữa 2 Buffer gần nhất
[Buffers]     Ctrl + w           | 🗑️ Đóng Buffer hiện tại (Buffer Delete)

[Editing]     Ctrl + z           | ↩️ Hoàn tác hành động trước đó (Undo)
[Editing]     Ctrl + Shift + z   | ↪️ Làm lại hành động vừa Undo (Redo)
[Editing]     Ctrl + Shift + k   | ✂️ Xóa nhanh dòng hiện tại (Normal) hoặc khối (Visual)
[Editing]     Ctrl + d (Visual)  | 👯 Nhân bản (Duplicate) khối văn bản đang chọn

[Lines/Alt]   Alt + Mũi tên Lên   |    Di chuyển dòng hiện tại hoặc khối chọn lên trên
[Lines/Alt]   Alt + Mũi tên Xuống |    Di chuyển dòng hiện tại hoặc khối chọn xuống dưới
[Lines/Alt]   Alt+Shift+Mũi tênLên|    Sao chép dòng hoặc khối chọn lên phía trên
[Lines/Alt]   Alt+Shift+Mũi tênXuống|    Sao chép dòng hoặc khối chọn xuống phía dưới

[Indentation] Tab (Visual)       |    Thụt lề dòng/khối chọn sang phải và giữ vùng chọn
[Indentation] Shift+Tab (Visual) |    Thụt lề dòng/khối chọn sang trái và giữ vùng chọn
[Indentation] Tab (Normal)       |    Thụt lề dòng hiện tại sang phải
[Indentation] Shift+Tab (Normal) |    Thụt lề dòng hiện tại sang trái

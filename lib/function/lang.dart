const lang = {
  "RESEND_VERIFY_EMAIL_SUCCESS":
      "Resend verify berhasil, silahkan periksa email Anda",
  "MINIMUM_CHANNEL_PRICE_IS_[price]": "Minimum harga channel adalah [price]",
  "CHANNEL_NAME_ALREADY_TAKEN": "Judul channel sudah dipakai nih",
  'CHANNEL_NOT_SUBSCRIBED: [channel_id]': 'Anda belum subscribe',
  'REQUESTED_SIGNAL_NOT_FOUND': 'Tidak menemukan signal yang minta',
  'CHANNEL_NOT_FOUND': 'Tidak menemukan channel',
  'CANNOT_SUBSCRIBE_OWNED_CHANNEL': 'Tidak bisa subscribe channel Anda sendiri',
  'CHANNEL_IS_PRIVATE': 'Channel ini bersifat pribadi',
  'CHANNEL_IS_NOT_FREE': 'Channel ini berbayar',
  'PAYMENT_METHOD_UNAVAILABLE': 'Metode pembayaran tidak tersedia',
  'PLEASE_WAIT_FOR_[limit_extend]_DAY_BEFORE_EXPIRED':
      'Mohon menunggu [limit_extend] hari sebelum expired',
  'PAYMENT_IS_NOT_OWNED': 'Pembayaran tidak tersedia',
  'CREATE_CHANNEL_IS_TEMPORARY_DISABLED':
      'Untuk sementara tidak bisa membuat channel',
  'YOU_CAN_ONLY_HAVE_[max_channel_count]_CHANNEL':
      'Anda bisa memiliki hingga [max_channel_count] channel',
  'MINIMUM_CHANNEL_PRICE_IS_[min_channel_price]':
      'Harga minimum channel [min_channel_price]',
  'SPECIAL_PRICE_MUST_BE_LOWER_THAN_NORMAL_PRICE':
      'Harga khusus harus lebih rendah daripada harga umum',
  'SPECIAL_PRICE_MUST_BE_HIGHER_THAN_LOWER_PERIOD':
      'Harga khusus harus lebih tinggi daripada harga pada periode sebelumnya',
  'MT4SERVER_IS_INCORRECT': 'Salah memasukkan server MT4',
  'MT4_ACCOUNT_NOT_FOUND': 'Tidak menemukan akun MT4',
  'YOU_ARE_NOT_OWNER_OF_THIS_CHANNEL': 'Anda bukan pemilih channel ini',
  'CANNOT_UPDATE_CHANNEL': 'Tidak bisa memperbarui channel',
  'EXPECTED_CHANNEL_NOT_FOUND': 'Tidak menemukan channel yang diinginkan',
  'REQUEST_CASH_OUT_BETWEEN_DATE_[min_date]_AND_[max_date]':
      'Mengajukan penarikan dana antara tanggal [min_date] dan [max_date]',
  'MINIMUM_CASH_OUT_[min_cash_out]': 'Minimum penarikan dana [min_cash_out]',
  'YOU_DIDNT_SUBSCRIBE_THIS_CHANNEL': 'Anda tidak subscribe channel ini',
  'CREATE_SIGNAL_IS_TEMPORARY_DISABLED':
      'Untuk sementara tidak bisa membuat signal',
  'Command Operation Not Found': 'Tidak bisa menemukan perintah operasi',
  'Unknown Channel': 'Channel tidak dikenal',
  'Instrument must be filled': 'Anda harus mengisi kolom `Instrument`',
  'Price must be filled': 'Anda harus memasukkan harga',
  'Unknown Command, available command: BUY_LIMIT, SELL_LIMIT, BUY_STOP, SELL_STOP':
      'Perintah tidak diketahui. Pilih yang tersedia: Buy Limit, Sell Limit, Buy Stop, atau Sell Stop',
  'Unknown User': 'User tidak diketahui',
  'Expired must be lower than 24 hour': 'Batas expiry harus kurang dari 24 jam',
  'Expired must be lower than [hari_expired] x 24 hour':
      'Batas expiry harus kurang dari [hari_expired] x 24 jam',
  'Signal is not owned by user': 'Signal ini bukan milik user',
  'Server Config Not Found': 'tidak menemukan konfigurasi server',
  'CANNOT_CLOSE_RUNNING_SIGNAL': 'Tidak bisa menutup signal yang `Running`',
  'GET_SYMBOL_FAILED': 'Gagal mendapatkan simbol',
  'INVALID_BROKER_NAME': 'Nama broker tidak valid',
  'OK': '`Ok? Gagal mengeksekusi trade',
  'DATE_FORMAT_ERROR_YYYY-MM-DD': 'Format tanggal salah (YYYY-MM-DD)',
  'DATE_RANGE_MAX_30_DAYS': 'Rentang tanggal hingga 30 hari',
  'CANNOT_UPDATE_SIGNAL': 'Tidak bisa memperbarui signal',
  'SIGNAL_NOT_FOUND': 'Tidak menemukan signal',
  'R:R ratio must be 2:1 or better': 'R:R Ratio harus 2:1 atau lebih besar',
  'R:R ratio must be 1.5:1 or better': 'R:R Ratio harus 1.5:1 atau lebih besar',
  'INVALID_PRICE': 'Harga tidak valid',
  'INVALID_TP': 'TP tidak valid',
  'INVALID_SL': 'SL tidak valid',
  'MINIMUM_200_PIPS_FROM_CURRENT_PRICE':
      'Input price minimal 20.0 pips dari harga sekarang',
  "MINIMUM_PRICE_200_PIPS_FROM_CURRENT_PRICE":
      "Input price minimal 20.0 pips dari harga sekarang",
  "MINIMUM_TP_200_PIPS_FROM_PRICE":
      "Input TP minimal 20.0 pips dari input price",
  "MINIMUM_SL_200_PIPS_FROM_PRICE":
      "Input SL minimal 20.0 pips dari input price",
  'FILE_TOO_BIG': 'Ukuran file terlalu besar',
  'NAMA_CHANNEL_SUDAH_ADA': 'Nama channel sudah ada',
  'NAMA_CHANNEL_MENGANDUNG_KATA_TERLARANG': 'Nama channel tidak diperbolehkan',
  'SEMUA_KOLOM_HARUS_DIISI': 'Semua kolom harus diisi',
  'NAMA_CHANNEL_HARUS_ANTARA_6_24_KARAKTER': 'Nama channel harus 6-24 karakter',
  'REKENING_DAN_NAMA_TIDAK_BOLEH_KOSONG':
      'Silakan mengisi rekening dan nama pemilik',
  'BANK_TIDAK_TIDAK_ADA': 'Tidak menemukan bank',
  'BANK_TIDAK_BOLEH_LEBIH_DARI_16_KARAKTER':
      'Nama bank tidak boleh lebih dari 16 karakter',
  'REKENING_TIDAK_BOLEH_LEBIH_DARI_16_KARAKTER':
      'Nomor rekening tidak boleh lebih dari 16 karakter',
  'REKENING_TIDAK_BOLEH_LEBIH_DARI_40_KARAKTER':
      'Nomor rekening tidak boleh lebih dari 40 karakter',
  'GAGAL_MENYIMPAN_INFO_BANK': 'Gagal menyimpan info bank',
  'CANNOT_FETCH_SUMMARY': 'Tidak bisa mengambil summary',
  'PAYMENT_ERROR': 'Gagal memproses pembayaran',
  'SUBSCRIPTION_TOKEN_NOT_FOUND': 'Tidak menemukan token subscription',
  'SUBSCRIPTION_TOKEN_NOT_MATCH': 'Token subscription tidak cocok',
  'SUBSCRIPTION_TOKEN_ALREADY_CLAIMED': 'Token subscription sudah diklaim',
  'ONLY_[max_request]_CASH_OUT_REQUEST_PER_PERIOD':
      'Hanya bisa [max_request] kali menarik dana per periode',
  'CASH_OUT_TEMPORARILY_DISABLED': 'Untuk sementara tidak bisa menarik dana',
  'BALANCE_NOT_ENOUGH': 'Saldo tidak cukup',
  'WD_NOT_FOUND': 'Tidak menemukan withdraw',
  'USER_NOT_FOUND': 'Tidak menemukan user',
  'CREATE_SIGNAL_IS_DISABLED_FOR_THIS_CHANNEL':
      'Channel ini tidak bisa membuat signal',
  'SIGNAL_WITH_SAME_PAIR_ALREADY_EXIST': 'Sudah ada signal pada pair ini',
  'Take Profit must be filled': 'Pasang `Take Profit`',
  'Stop Loss must be filled': 'Pasang `Stop Loss`',
  'BUY_OR_SELL_MARKET_EXECUTION_ONLY_WHEN_ACCOUNT_CONNECTED_TO_CHANNEL':
      'Hanya menggunakan `Market Execution` saat akun terhubung ke channel',
  'MARKET_CLOSED_OR_SYMBOL_NOT_FOUND':
      'Market tutup atau simbol tidak ditemukan',
  'CANT_INSERT_TO_DATABASE': 'Tidak bisa memasukkan data',
  'UNABLE_MAKE_PENDING_TRADE': 'Tidak bisa pending order',
  'Data is not valid': 'Data tidak valid',
  'CANT_UPDATE_TO_DATABASE': 'Tidak bisa memperbarui data',
  'LOGIN_FAILED_PLEASE_CHECK_EMAIL':
      "Kombinasi email / username dengan password salah",
  'UPDATE_CHANNEL_PRICE_MAX_ONCE_PER_[month]_MONTH_NEXT_[next_month]':
      'Update harga channel hanya sekali dalam [month] bulan, update lagi setelah tanggal [next_month]',
  'AUTHORIZATION_TOKEN_EXPIRED': 'Token Otorisasi Kadaluarsa',
  'UNKNOWN_USER_ERROR_PLEASE_LOGIN_FIRST':
      'User Tidak Dikenal. Silakan Login Terlebih Dahulu',
  'REQUEST_VALIDATION_ERROR': 'Permintaan Validasi Gagal',
  'MRG_MEGA_BERJANGKA_ACCOUNT_NOT_FOUND': 'Akun DEFGHIJK Tidak Ditemukan',
  'FILE_FORMAT_NOT_ALLOWED': 'Format File Tidak Didukung',
  'MAX_FILE_SIZE_1MB': 'Ukuran Maksimal 1MB',
  'SOME_FILE_MISSING_OR_FAILED': 'Beberapa File Hilang atau Gagal',
  'NO_REQUEST_SAVED': 'Permintaan Gagal Tersimpan',
  'INVALID_ACCOUNT_TYPES': 'Tipe Akun Tidak Valid',
  'CANT_CONNECT_TO_API': 'Terjadi Kesalahan Koneksi',
  'ALREADY_REGISTERED': 'Email Sudah Terdaftar',
  'CANT_CONNECT_TO_MRG_MEGA_BERJANGKA_API': 'Gagal Terhubung ke DEFGHIJK API',
  'CANT_CONNECT_TO_ASKAP_API': 'Gagal Terhubung ke Askap API',
  'This function is not Available for this API':
      'Fungsi Ini Tidak Tersedia di API',
  'MISSING_REQUEST_PARAMETER': 'Permintaan Parameter Hilang',
  'UNKNOWN_COMMAND_ERROR': 'Perintah Tidak Dikenal',
  'INVALID_DATA': 'Data Tidak Valid',
  'UNKNOWN_MT4_FUNCTION': 'Fungsi MT4 Tidak Dikenal',
  'MMB_ACCOUNT_NOT_FOUND': 'Akun MMB Tidak Ditemukan',
  'MT4_ACCOUNT_NOT_OWNED': 'Tidak Memiliki Akun MT4',
  'PLEASE_WAIT_MULTIPLE_DEPOSIT_MRG_MEGA_BERJANGKA':
      'Mohon Menunggu. Deposit Sedang Dalam Proses',
  'PLEASE_WAIT_FOR_NEW_ACCOUNT_DEPOSIT_PROCESSED':
      'Mohon Menunggu. Akun Deposit Sedang Diproses',
  'MRG_ACCOUNT_USER_NOT_FOUND': 'Pengguna Akun MRG Tidak Ditemukan',
  'MRG_ACCOUNT_TYPE_NOT_FOUND': 'Tipe Akun MRG Tidak Ditemukan',
  'FIRST_DEPOSIT_MINIMUM_USD_[mindepo]':
      'Minimum Deposit Pertama USD [minDepo]',
  'ALREADY_HAVE_DEMO_ACCOUNT': 'Sudah Memiliki Akun Demo',
  'FAILED_TO_SAVE_REQUEST': 'Permintaan Gagal',
  'WAIT_REQUEST_BEING_IS_PROCESSED': 'Permintaan Sedang Diproses',
  'FAILED_TO_UPDATE_REQUEST': 'Permintaan Update Gagal',
  'NOT_VALID_KRITERIA': 'Kriteria Tidak Valid',
  'UNKNOWN_MT4_LOGIN': 'Login Tidak Dikenal',
  'CANT_LOGIN_TO_MT4': 'Tidak Dapat Login ke MT4',
  'MRG_ACCOUNT_NOT_FOUND': 'Akun MRG Tidak Ditemukan',
  'BANK_NOT_FOUND': 'Bank Tidak Ditemukan',
  'USER_BANK_NOT_FOUND': 'Nama Pemilik Rekening Tidak Ditemukan',
  'CANNOT_CHANGE_BANK': 'Bank Tidak Dapat Diubah',
  'CANT_CONNECT_TO_MT4': 'Gagal Terhubung ke MT4',
  'EMPTY_HISTORY': 'Riwayat Kosong',
  'MAX_UPLOAD_SIZE_2MB': 'Ukuran Maksimal 2MB',
  'INVALID_BANK': 'Bank Tidak Valid',
  'CANT_CONNECT_TO_MRG_API': 'Gagal Terhubung ke MRG API',
  'PLEASE_WAIT_MULTIPLE_DEPOSIT_MRG':
      'Mohon Menunggu. Deposit Sedang Dalam Proses',
  'DONT_DO_THAT': 'Kesalahan Server',
  'MISSING_REQUEST_QUERY_ERROR': 'Permintaan Gagal',
  'EVENT_NOT_REGISTERED': 'Event Tidak Terdaftar',
  'INVALID_USERID_PARAMETER': 'Parameter User ID Tidak Valid',
  'INVALID_REQUEST_PARAMETER': 'Parameter Permintaan Tidak Valid',
  'CLASS_NOT_FOUND': 'Kelas Tidak Ditemukan',
  'UNKNOWN_BRANCH': 'Cabang Tidak Dikenal',
  'INVALID_MT4_ACCOUNT': 'Akun MT4 Tidak Valid',
  'Unknown User ID': 'User ID Tidak Dikenal',
  'UNKNOWN_USERID': 'User ID Tidak Dikenal',
  'CANT_UPDATE_TOKEN': 'Gagal Update Token',
  'AUTHORIZATION_ERROR': 'Terjadi Kesalahan',
  'UNKNOWN_USER': 'User Tidak Dikenal',
  'YYYY-MM-DD HH:mm:ssZ': 'Format Data (YYYY-MM-DD)',
  'LINK_HAS_EXPIRED': 'Link Kadaluarsa',
  'USERS_NOT_FOUND': 'User Tidak Ditemukan',
  'SAVE_CALLBACK_FAILED': 'Permintaan Callback Gagal',
  'INBOX_NOT_FOUND': 'Pesan Tidak Ditemukan',
  'ENCRYPTED_TEXT_MUST_NOT_BE_EMPTY': 'Teks Enkripsi Harus Diisi',
  'DECRYPTED_TEXT_MUST_NOT_BE_EMPTY': 'Teks Dekripsi Harus Diisi',
  'STRING_MUST_BE_FILLED': 'Rangkaian Harus Diisi',
  'INVALID_UID': 'UID Tidak Valid',
  'INVALID_FCM': 'FCM Tidak Valid',
  'INVALID_USERID': 'User ID Tidak Valid',
  'INVALID_DEVICE_TOKEN': 'Akses Token Tidak Valid',
  'INVALID_DATA_OR_NOTIFICATION': 'Data Tidak Valid atau Notifikasi',
  'INVALID_EMAIL_NAME': 'Nama Email Tidak Valid',
  'FAILED_TO_REGISTER': 'Registrasi Gagal',
  'REQUEST_PARAMETER_MUST_CONTAIN_USERID':
      'Permintaan Parameter Harus Mengandung User Id ',
  'REQUEST_PARAMETER_MUST_CONTAIN_EMAIL_AND_PASSWORD':
      'Permintaan Parameter Harus Mengandung Email dan Password',
  'LOGIN_FAILED_PLEASE_CHECK_EMAIL_OR_USERNAME':
      'Login Gagal. Periksa Kembali Email atau Username Yang Digunakan',
  'LOGIN_FAILED_PLEASE_CHECK_PASSWORD':
      'Login Gagal. Periksa Kembali Password Yang Digunakan',
  'USERID_AND_PASSWORD_CANT_BE_EMPTY': 'User ID dan Password Harus Diisi',
  'PASSWORD_MUST_BE_6_12_CHARACTERS':
      'Password Harus Mengandung 6 - 12 Karakter',
  'INVALID_OLD_PASSWORD': 'Password Lama Tidak Valid',
  'UNKNOWN_USER_REQUESTED': 'Permintaan Pengguna Tidak Dikenal',
  'CABANG_IS_REQUIRED': 'Cabang Harus Diisi',
  'EMAIL_IS_NOT_VALID': 'Email Tidak Valid',
  'NAME_MUST_BETWEEN_4_AND_50_CHARACTERS':
      'Nama Harus Mengandung 4 - 50 Karakter',
  'PASSWORD_MUST_BETWEEN_6_AND_12_CHARACTERS':
      'Password Harus Mengandung 6 - 12 Karakter',
  'INVALID_PHONE_NUMBER': 'Nomor Telepon Tidak Valid',
  'PROHIBITED_NAME': 'Nama Dilarang',
  'INVALID_COUNTRY': 'Negara Tidak Valid',
  'INVALID_OFFICE_BRANCH': 'Kantor Cabang Tidak Valid',
  'EMAIL_IS_ALREADY_REGISTERED': 'Email Sudah Terdaftar',
  'CANT_INSERT_NEW_DATA_TO_USERS': 'Gagal Memuat Data Baru',
  'NAME_MUST_BE_ALPHANUMERIC': 'Nama Harus Alfanumerik',
  'INVALID_CITY': 'Kota Tidak Valid',
  'USERID_IS_NOT_NUMBER': 'User Id Tidak Boleh Angka',
  'ACTOR_IS_NOT_NUMBER': 'Actor Tidak Boleh Angka',
  'ZIPCODE_IS_NOT_VALID': 'Kode Pos Tidak Ditemukan',
  'USERNAME_CANT_BE_CHANGED': 'Username Tidak Dapat Diubah',
  'USER_NOT_VERIFIED': 'Akun Tidak Terverifikasi',
  'USERNAME_MUST_BE_ALPHA_NUMERIC': 'Username Harus Alfanumerik',
  'USERNAME_MUST_BETWEEN_6_AND_16_CHARACTERS':
      'Username Harus Mengandung 6 -16 Karakter',
  'USERNAME_IS_NOT_AVAILABLE': 'Username Tidak Tersedia',
  'YOU_CANT_CHANGE_OTHERS_PROFILE': 'Profil Orang Lain Tidak Dapat Diubah',
  'USERNAME_MUST_BE_ALPHANUMERIC': 'Username Harus Alfanumerik',
  'BANNED_WORDS_USERNAME': 'Username Dibanned',
  'CHANGE_EMAIL_PROHIBITED': 'Dilarang Mengubah Email',
  'FULLNAME_MUST_BETWEEN_6_AND_50_CHARACTERS':
      'Nama Lengkap Harus Mengandung 6 - 50 Karakter',
  'ADDRESS_MUST_BE_FILLED': 'Alamat Harus Diisi',
  'UPDATE_USER_ERROR_PLEASE_TRY_AGAIN': 'Terjadi Kesalahan. Silakan Coba Lagi',
  'CALLBACK_ALREADY_REQUEST': 'Permintaan Callback Sudah Diterima',
  'REQUEST_CALLBACK_TIME_MUST_HIGHER_THAN_NOW':
      'Waktu Permintaan Callback Harus Diatas Sekarang',
  'REQUEST_CALLBACK_TIME_MUST_BE_LOWER_THAN_17:00_(WESTERN_INDONESIAN_TIME)':
      'Waktu Permintaan Callback Tidak Lebih dari 17:00 (WIB)',
  'REQUEST_CALLBACK_TIME_MUST_BE_HIGHER_THAN_10:30_(WESTERN_INDONESIAN_TIME)':
      'Waktu Permintaan Callback Harus Diatas 10:30 (WIB)',
  'REQUEST_CALLBACK_TIME_MUST_ON_WEEKDAYS':
      'Waktu Permintaan Callback Hanya Dapat di Hari Kerja',
  'REQUEST_CALLBACK_TIME_CANT_BE_MORE_THAN_ONE_WEEK_FROM_NOW':
      'Waktu Permintaan Callback Tidak Dapat Lebih Dari 1 Minggu Dari Sekarang',
  'EMAIL_IS_NOT_REGISTERED': 'Email Tidak Terdaftar',
  'Invalid Token': 'Token Tidak Valid',
  'CHANNEL_NOT_SUBSCRIBED': 'Channel Belum Disubscribe',
  'WRONG_PARAMETER': 'Paramater Salah',
  'MISSIG_REQUEST_PARAMETER': 'Permintaan Parameter Hilang',
  'Payment Service is under maintenance. Please try again later.':
      'Sistem Pembayaran Dalam Perbaikan. Silakan Coba Beberapa Saat Lagi',
  'CHANNEL_IS_FREE': 'Channel Gratis',
  'PLEASE_WAIT_FOR_[limitExtend]_DAY_BEFORE_EXPIRED':
      'Silakan Tunggu [limitExtend] Hari Sebelum Kadaluarsa',
  'PAYMENT_NOT_FOUND': 'Pembayaran Tidak Ditemukan',
  'Inquiry Payment Status Difference': 'Permintaan Perbedaan Status Pembayaran',
  'POINT_MUST_BE_POSITIVE_NUMBER': 'Point Harus Angka Positif',
  'POINT_MUST_BE_MULTIPLY_OF_[config.POINT_EXCHANGE_MULTIPLY]':
      'Point Harus Berkelipatan [config.POINT_EXCHANGE_MULTIPLY],TF point harus berkelipatan 10',
  'REQUEST_EXCHANGE_POINT_BETWEEN_DATE_[minDate]_AND_[maxDate]':
      'Permintaan Penukaran Point Harus di Antara [minDate] dan [maxDate]',
  'YOU_CAN_ONLY_HAVE_[process.env.OIS_MAX_CHANNEL_OWNED]_CHANNEL':
      'Channel Maksimal Adalah [process.env.OIS_MAX_CHANNEL_OWNED]',
  'MINIMUM_CHANNEL_PRICE_IS_[process.env.OIS_MINIMUM_PAID_CHANNEL]':
      'Harga Mininum Channel Adalah [process.env.OIS_MINIMUM_PAID_CHANNEL]',
  'UPDATE_CHANNEL_PRICE_MAX_ONCE_PER_[interval]_MONTH_NEXT_[nextUpdatePrice.format()]':
      'Update Harga Channel Maksimal [interval] Kali Per Bulan. Ganti Selanjutnya [nextUpdatePrice.format()]',
  'REQUEST_CASH_OUT_BETWEEN_DATE_[minDate]_AND_[maxDate]':
      'Tanggal Permintaan Cashout Harus di Antara [minDate] dan [maxDate]',
  'MINIMUM_CASH_OUT_[process.env.OIS_MINIMUM_CASH_OUT]':
      'Minimum Cashout [process.env.OIS_MINIMUM_CASH_OUT]',
  'Unknown Command available command: "BUY_LIMIT SELL_LIMIT BUY_STOP SELL_STOP"':
      'Sistem Operasi Tidak Dikenal: "Buy Limit, Sell Limit, Buy Stop, Sell Stop"',
  'Expired must be lower than [hariExpired] x 24 hour':
      'Masa Kadaluarsa Harus Lebih Rendah dari [hariExpired]',
  'CANNOT_CLOSE_RUNNING_SIGNAL_PLEASE_WAIT_FOR_SYNC':
      'Tidak Dapat Menutup Running Signal. Silakan Tunggu Sinkronisasi',
  'HARGA_MINIMAL_50000': 'Harga Minimal 50000',
  'PRICE_MUST_BETWEEN_0_AND_100000000': 'Harga Harus di Antara 0 dan 100000000',
  'INVALID_PARAMETER': 'Parameter Tidak Valid',
  'EMPTY_PARAMETER': 'Parameter Kosong',
  'newSubscription': 'Subscriber Baru',
  'ONLY_[maxRequest]_CASH_OUT_REQUEST_PER_PERIOD':
      'Cashout Hanya Dapat Dilakukan [maxRequest] Setiap Periode',
  'REDEEM_NOT_FOUND': 'Penukarana Tidak Ditemukan',
  'CHANNEL_LEVEL_NOT_ENOUGH': 'Level Channel Tidak Cukup',
  'POINT_NOT_ENOUGH': 'Point Tidak Cukup',
  'PROGRAM_BELUM_DIMULAI': 'PROGRAM_BELUM_DIMULAI',
  'MAX_DAILY_SIGNAL_HAS_BEEN_REACHED': 'Sudah Mencapai Maksimal Signal Harian',
  'MARKET_CLOSED_OR_SYMBOL_COMMON_ERROR':
      'Market Tutup atau Simbol Tidak Ditemukan',
  'UNKNOWN_SERVER': 'Server Tidak Diketahui',
  'CANNOT_UPDATE_RUNNING_SIGNAL': 'Running Signal Tidak Dapat Diupdate',
  'CANNOT_UPDATE_EXPIRATION_MUST_BELOW_24_HOUR_BEFORE_EXTEND':
      'Gagal Memperbaharui. Masa Kadaluarsa Harus di Bawah 24 Jam Sebelum Perpanjang',
  'CANNOT_UPDATE_EXPIRATION_MUST_BE_[hariExpired]_DAYS':
      'Gagal Memperbaharui. Masa Kadaluarsa Harus [hariExpired] Hari',
  'PLEASE_LOGIN_FIRST': 'Silakan Login Terlebih Dahulu',
  'UNKNOWN_MRG_ID_PLEASE_CONTACT_ADMIN':
      'ID MRG Tidak Dikenal. Silakan Hubungi Admin',
  'REQUIRED_ID': 'ID Dibutuhkan',
  'DEPOSIT_HAS_BEEN_PROCESSED': 'Deposit Sedang Diproses',
  'INVALID_ACCOUNT_INPUT': 'Input Akun Tidak Valid',
  'INVESTOR_NOT_FOUND: [account]': 'Investor Tidak Ditemukan: [account]',
  'INVALID_INTERNAL_TRANSFER': 'Internal Transfer Tidak Valid',
  'User not found': 'User Tidak Ditemukan',
  'INVALID_ACCOUNT_TYPE': 'Tipe Akun Tidak Valid',
  'MUST_SPECIFY_RATE_AND_DEPOSIT_ID': 'Rate dan Deposit ID Harus Ditetapkan',
  'MUST_SPECIFY_RATE_AND_TRANSFER_ID': 'Rate dan Transfer ID Harus Ditetapkan',
  'MUST_SPECIFY_RATE_AND_WITHDRAW_ID': 'Rate dan Withdraw ID Harus Ditetapkan',
  'MUST_SPECIFY_TRANSFER_ID': 'Transfer ID Harus Ditetapkan',
  'IP_REQUIRED': 'IP Dibutuhkan',
  'WITHDRAWAL_FAILED': 'Penarikan Dana Gagal',
  'EMAIL_DETAIL_NOT_FOUND': 'Detail Email Tidak Ditemukan',
  'EMAIL_NOT_FOUND': 'Email Tidak Ditemukan',
  'WITHDRAW_NOT_FOUND_WITH_ID:#[id]':
      'Withdraw Tidak Ditemukan [id],withdraw tidak ditemuka',
  'UNKNOWN_DEPOSIT_RATE': 'Rate Deposit Tidak Dikenal',
  'WITHDRAW_HAS_BEEN_PROCESSED': 'Withdraw Sedang Diproses',
  'INVALID_AMOUNT: [amount]': 'Jumlah Tidak Valid: [amount]',
  'DEPOSIT_NOT_FOUND': 'Deposit Tidak Ditemukan',
  'TOPUP_INVALID_AMOUNT_MUST_BE_ABOVE_ZERO':
      'Deposit Harus di Atas 0,deposit harus di atas ',
  'WITHDRAW_NOT_FOUND': 'Withdraw Tidak Ditemukan',
  'REQUESTED_LOGIN_ISNOT_SAME_AS_DATABASE': 'Data Tidak Sesuai',
  'USER_GROUP_ISNOT_ALLOWED [users.group]': 'User Group Tidak Diperbolehkan',
  'INTERNAL_TRANSFER_NOT_FOUND': 'Internal Transfer Tidak Ditemukan',
  'INTERNAL_TRANSFER_HAS_BEEN_PROCESSED': 'Internal Transfer Sedang Diproses',
  'WITHDRAW_RATEVAL_MUST_BE_ABOVE_10000':
      'Withdraw Harus di Atas 10000,withdraw harus diatas 1000',
  'DEPOSIT_RATEVAL_MUST_BE_ABOVE_10000':
      'Deposit Harus di Atas 0,deposit harus diatas 1000',
  'INVALID_WITHDRAW_AMOUNT: [wdAmount]':
      'Jumlah Withdraw Tidak Valid: [wdAmount],jumlah withdraw invalid',
  'INVALID_DEPOSIT_AMOUNT: [topUpNormalize]':
      'Jumlah Deposit Tidak Valid: [topUpNormalize]',
  'You already have requested the same request [moment.unix(last.time).fromNow()]. Please wait for [waitMinute] minutes.':
      'Permintaan Sudah Diterima. Mohon Menunggu, sudah ada request yang sama, mohon tunggu',
  "Please wait for this account's first deposit to be processed.":
      'Mohon Menunggu Deposit Pertama Untuk Diproses, mohon tunggu first deposit akun ini untuk di proses',
  '[metaserver_id]_NOT_FOUND': '[metaserver_id] Tidak Ditemukan',
  'DONT_HAVE_PERMISSION_TO_CHANGE_BANK': 'Anda Tidak Dapat Mengubah Bank',
  'SOMETHING_WENT_WRONG': 'Terjadi Kesalahan',
  'ACCOUNT_TYPE_NOT_FOUND': 'Tipe Akun Tidak Ditemukan',
  'FIRST_DEPO_MIN_IDR_[minDepo]': 'Depo Pertama Minimal: [minDepo]',
  'FAILED_TO_RECORD': 'Gagal Menyimpan Data,Gagal menyimpa',
  'MAX_FILE_SIZE_FILE_1MB': 'Ukuran Maksimal 1MB',
  'DEPO_UPLOAD_PROOF_FAILED': 'Bukti Upload Deposit Gagal',
  'META_ACCOUNT_NOT_FOUND': 'Akun Meta Tidak Ditemukan',
  'EQUITY_NOT_FOUND': 'Ekuitas Tidak Cukup',
  'Your MRG Account is not belong to our system...':
      'Akun MRG Tidak Ditemukan,MRG account tidak ditemuka',
  'NOT_ENOUGH_RIGHTS': 'Akses Ditolak,Hak akses tidak cuku',
  'You are not authorized': 'Permintaan Tidak Diizinkan,Tidak diijinka',
  'Please login first': 'Silahkan Login Terlebih Dahulu',
  'UNKNOWN_MMB_ID_PLEASE_CONTACT_ADMIN':
      'ID MMB Tidak Dikenal. Silakan Hubungi Admin',
  'PASSWORD_IS_REQUIRED': 'Password Dibutuhkan',
  'PASSWORD_NOT_SAME': 'Password Tidak Sama',
  'CANNOT_ENCRYPT_PASSWORD': 'Tidak Dapat Mengenkripsi Kata Sandi',
  'NOTHING_TO_UPDATE': 'Tidak Ada Pembaharuan',
  'INVALID_PASSWORD': 'Password Tidak Valid',
  'USER_ALREADY_EXIST': 'User Sudah Ada',
  'METAOFFICE_USER_NOT_FOUND': 'Metaoffice User Tidak Ditemukan',
  'YOU_CANT_USE_THIS_USERNAME': 'Username Tidak Dapat Digunakan',
  'USERNAME_EXIST': 'Username Sudah Digunakan',
  'PLEASE_INPUT_CRITERIA': 'Silakan Masukkan Criteria',
  'AFFILIATE_IS_REQUIRED': 'Affiliate Dibutuhkan',
  'AFFILIATE_NOT_FOUND': 'Affiliate Tidak Ditemukan',
  'FAILED_TO_FETCH_DATA': 'Tidak Dapat Memuat Ringkasan',
  'NO_ACCOUNT_FOUND': 'Akun Tidak Ditemukan',
  'WRONG_RECENT_PASSWORD': 'Password Salah',
  'INVALID_USER_ID': 'User ID Tidak Valid',
  'BIRTHDATE_IS_INVALID': 'Tanggal Lahir Tidak Valid',
  'Unknown Affiliate': 'Affiliate Tidak Dikenal',
  'RECORD_ALREADY_EXIST': 'Data Sudah Ada',
  'Invalid from and to datetime': 'Tanggal Salah',
  'EMAIL_ALREADY_VALIDATED': 'Email Sudah Divalidasi',
  'MT4ID_NOT_FOUND': 'ID MT4 Tidak Ditemukan',
  'REGISTER_FAILED': 'Registrasi Gagal',
  'LOGIN_FAILED_PLEASE_CHECK_USERNAME': 'Login Gagal. Periksa Kembali Username',
  'No Available Account': 'Akun Tidak Tersedia'
};
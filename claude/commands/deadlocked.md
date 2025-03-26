Identify the source code responsible for a MySQL deadlock. A lot of the resources we need don't have good APIs or MCP
servers at the moment. Follow these steps.
1. Prompt me to paste the SQL statement found on the "EXCEPTION ATTRIBUTES" tab in the Bugsnag event.
2. Get the request_id and pod_id from the SQL Statement. The SQL statement will look something like this:
   ```sql
   /*action:query,api_client_id:34646425601,application:Shopify,capacity_scope:general,consistent_read_id:7f805a65-7c44-4f5b-8d2f-1bf0a534accc,controller:admin/graphql,pod_id:296,request_id:2e084b91-c94c-42ed-a7ff-540bb7dfaa8d-1742945121,request_priority:medium,role:rw,shop_id:68267966761*/ UPDATE `orders` SET `orders`.`updated_at` = '2025-03-25 23:25:21.390250' WHERE `orders`.`shop_id` = 68267966761 AND `orders`.`id` = 6378332422441
   ```
   Every SQL statement in Core has the comment at the beginning with request metadata. Most will include the
   `request_id` and `pod_id` fields. If there is no `request_id`, you can use the `job_id` instead. If there is no
   `pod_id`, prompt me to paste it from the "ERROR SOURCE" tab in the Bugsnag event. Do not use the information in my
   example in this prompt, use the input provided after you prompt me.
3. Output the URL to the MySQL Deadlock logs in Observe. The link will look like the following:
   ```
   https://observe.shopify.io/a/observe/investigate/logs?r=%7B%22from%22%3A%22now-30m%22%2C%22to%22%3A%22now%22%7D&q=%7B%22refId%22%3A%221%22%2C%22viewMode%22%3A%22builder%22%2C%22queryStep%22%3A%22%22%2C%22queryMode%22%3A%22search%22%2C%22rawDataMode%22%3Afalse%2C%22request%22%3A%7B%22datasets%22%3A%5B%22mysql%22%5D%2C%22filter_combination%22%3A%22AND%22%2C%22filters%22%3A%5B%5D%2C%22filter_group%22%3A%7B%22conjunction%22%3A%22AND%22%2C%22filter_groups%22%3A%5B%7B%22conjunction%22%3A%22AND%22%2C%22filters%22%3A%5B%7B%22column%22%3A%22message%22%2C%22op%22%3A%22contains%22%2C%22value%22%3A%22<request_id|job_id>%22%7D%2C%7B%22column%22%3A%22host%22%2C%22op%22%3A%22starts-with%22%2C%22value%22%3A%22shard<pod_id>%22%7D%2C%7B%22column%22%3A%22deadlock%22%2C%22op%22%3A%22%3D%22%2C%22value%22%3A%22true%22%7D%5D%7D%5D%2C%22filters%22%3A%5B%5D%7D%7D%2C%22templateVariables%22%3A%5B%5D%7D
   ```
   Except replace <request_id|job_id> with the request_id you found or the job_id if you didn't find a request_id and
   replace <pod_id> with the pod_id you found or received.
4. Insert the url in my copy-paste buffer. If I accept it, you can just echo the URL and pipe it into `pbcopy`. It will
   look something like the following:
   ```
   echo "https://observe.shopify.io/a/observe/investigate/logs?r=%7B%22from%22%3A%22now-30m%22%2C%22to%22%3A%22now%22%7D&q=%7B%22refId%22%3A%221%22%2C%22viewMode%22%3A%22builder%22%2C%22queryStep%22%3A%22%22%2C%22queryMode%22%3A%22search%22%2C%22rawDataMode%22%3Afalse%2C%22request%22%3A%7B%22datasets%22%3A%5B%22mysql%22%5D%2C%22filter_combination%22%3A%22AND%22%2C%22filters%22%3A%5B%5D%2C%22filter_group%22%3A%7B%22conjunction%22%3A%22AND%22%2C%22filter_groups%22%3A%5B%7B%22conjunction%22%3A%22AND%22%2C%22filters%22%3A%5B%7B%22column%22%3A%22message%22%2C%22op%22%3A%22contains%22%2C%22value%22%3A%22<request_id|job_id>%22%7D%2C%7B%22column%22%3A%22host%22%2C%22op%22%3A%22starts-with%22%2C%22value%22%3A%22shard<pod_id>%22%7D%2C%7B%22column%22%3A%22deadlock%22%2C%22op%22%3A%22%3D%22%2C%22value%22%3A%22true%22%7D%5D%7D%5D%2C%22filters%22%3A%5B%5D%7D%7D%2C%22templateVariables%22%3A%5B%5D%7D" | pbcopy
   ```
5. Prompt me to paste the latest detected deadlock log message found in the link you just gave me. Remind me that the
   `deadlock_msg` column contains all the necessary data but is significantly smaller to copy than the entire INNODB
   MONITOR OUTPUT in the `message` column.
6. Identify the other query that is deadlocking with the first SQL statement I provided by checking the SQL statements
   of the two transactions that are deadlocking in the latest detected deadlock log. The latest detected deadlock log
   will look like this:
   ```
   LATEST DETECTED DEADLOCK
   ------------------------
   2025-03-25 14:58:06 139591155709696
   *** (1) TRANSACTION:
   TRANSACTION 65364055561, ACTIVE 0 sec starting index read
   mysql tables in use 1, locked 1
   LOCK WAIT 4 lock struct(s), heap size 1128, 2 row lock(s)
   MySQL thread id 2312033, OS thread handle 139667527915264, query id 102330085563 255.78.1.79 shopify_writer updating
   /*action:query,api_client_id:119385423873,application:Shopify,capacity_scope:general,consistent_read_id:98b81d4d-7bbd-42b6-a54a-1943d619f240,controller:admin/graphql,pod_id:265,request_id:249c0faf-95ec-4a76-b41c-e6a2060a5b96-1742914686,request_priority:medium,role:rw,shop_id:61331079307*/ UPDATE `orders` SET `orders`.`updated_at` = '2025-03-25 14:58:06.797734' WHERE `orders`.`shop_id` = 61331079307 AND `orders`.`id` = 6880292405514

   *** (1) HOLDS THE LOCK(S):
   RECORD LOCKS space id 4257 page no 1902755 n bits 144 index PRIMARY of table `shopify_shard_265`.`fulfillment_orders` trx id 65364055561 lock_mode X locks rec but not gap
   Record lock, heap no 74 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
   0: len 8; hex 80000741c293010a; asc    A    ;;
   1: len 6; hex 000f37fda86b; asc   7  k;;
   2: len 7; hex 0200002b90244a; asc    + $J;;
   3: len 8; hex 0000000e479e008b; asc     G   ;;
   4: len 8; hex 00000641f162810a; asc    A b  ;;
   5: len 11; hex 7373742d6e6c2d70726f64; asc sst-nl-prod;;
   6: len 11; hex 696e5f70726f6772657373; asc in_progress;;
   7: len 1; hex 81; asc  ;;
   8: len 1; hex 81; asc  ;;
   9: SQL NULL;
   10: len 8; hex 99b632eae202a6dd; asc   2     ;;
   11: len 8; hex 99b632ee490e899a; asc   2 I   ;;
   12: len 5; hex 99b632eae2; asc   2  ;;
   13: len 8; hex 000000159487010a; asc         ;;
   14: len 22; hex 63616e63656c6c6174696f6e5f726571756573746564; asc cancellation_requested;;
   15: len 1; hex 80; asc  ;;
   16: len 5; hex 99b632e000; asc   2  ;;
   17: SQL NULL;
   18: len 30; hex 38306530626339312d326138652d343262342d386561332d323362616161; asc 80e0bc91-2a8e-42b4-8ea3-23baaa; (total 36 bytes);


   *** (1) WAITING FOR THIS LOCK TO BE GRANTED:
   RECORD LOCKS space id 6782 page no 6186770 n bits 80 index PRIMARY of table `shopify_shard_265`.`orders` trx id 65364055561 lock_mode X locks rec but not gap waiting
   Record lock, heap no 12 PHYSICAL RECORD: n_fields 91; compact format; info bits 0
   0: len 8; hex 8000000e479e008b; asc     G   ;;
   1: len 8; hex 80000641f162810a; asc    A b  ;;
   2: len 6; hex 000f380055f0; asc   8 U ;;
   3: len 7; hex 02000008f52356; asc      #V;;
   4: len 8; hex 800013741791010a; asc    t    ;;
   5: len 8; hex 800013741790810a; asc    t    ;;
   6: len 30; hex 6c2e6f6569407368616e67686169686f74656c686f6c6c616e642e636f6d; asc l.oei@shanghaihotelholland.com;;
   7: SQL NULL;
   8: len 8; hex 99b632ead400a9d7; asc   2     ;;
   9: len 8; hex 99b632ee860c483f; asc   2   H?;;
   10: len 4; hex 800c6ba0; asc   k ;;
   11: SQL NULL;
   12: len 30; hex 353137326231613161616335633862376333313363656531393361313433; asc 5172b1a1aac5c8b7c313cee193a143; (total 32 bytes);
   13: SQL NULL;
   14: len 16; hex 73686f706966795f7061796d656e7473; asc shopify_payments;;
   15: len 1; hex 80; asc  ;;
   16: len 10; hex 800000000000041501c2; asc           ;;
   17: len 10; hex 800000000000040d00be; asc           ;;
   18: len 8; hex 0000000000000000; asc         ;;
   19: len 10; hex 80000000000000000000; asc           ;;
   20: len 1; hex 81; asc  ;;
   21: len 3; hex 455552; asc EUR;;
   22: len 4; hex 70616964; asc paid;;
   23: len 6; hex 646972656374; asc direct;;
   24: len 16; hex 23e298a031e298a20a2d2d2d207b7d0a; asc #   1    --- {} ;;
   25: len 1; hex 81; asc  ;;
   26: len 11; hex 756e66756c66696c6c6564; asc unfulfilled;;
   27: len 10; hex 80000000000000da0294; asc           ;;
   28: len 10; hex 80000000000004e603de; asc           ;;
   29: len 30; hex 5a324e774c575631636d39775a5331335a584e304e446f774d5570524e6c; asc Z2NwLWV1cm9wZS13ZXN0NDowMUpRNl; (total 58 bytes);
   30: len 1; hex 80; asc  ;;
   31: len 6; hex 383134393834; asc 814984;;
   32: SQL NULL;
   33: SQL NULL;
   34: len 30; hex 23e298a031e298a20a2d2d2d0a7365676d656e74436f6e663a20354f4267; asc #   1    --- segmentConf: 5OBg; (total 304 bytes);
   35: len 8; hex 80000937c414810a; asc    7    ;;
   36: SQL NULL;
   37: SQL NULL;
   38: len 10; hex 80000000000004690172; asc        i r;;
   39: len 30; hex 633566643134383535646166346665343534653938336631356566353834; asc c5fd14855daf4fe454e983f15ef584; (total 32 bytes);
   40: len 1; hex 80; asc  ;;
   41: len 10; hex 80000000000000090078; asc          x;;
   42: SQL NULL;
   43: SQL NULL;
   44: SQL NULL;
   45: len 8; hex 80002c553260010a; asc   ,U2`  ;;
   46: SQL NULL;
   47: len 1; hex 80; asc  ;;
   48: len 3; hex 623262; asc b2b;;
   49: len 6; hex 373231313632; asc 721162;;
   50: SQL NULL;
   51: SQL NULL;
   52: len 8; hex 99b632eacf0c5087; asc   2   P ;;
   53: SQL NULL;
   54: SQL NULL;
   55: SQL NULL;
   56: len 8; hex 80000000005e1aa1; asc      ^  ;;
   57: len 10; hex 80000000000004110140; asc          @;;
   58: len 10; hex 80000000000000000000; asc           ;;
   59: len 10; hex 80000000000000000000; asc           ;;
   60: len 8; hex 800000348e0b810a; asc    4    ;;
   61: len 1; hex 80; asc  ;;
   62: len 1; hex 81; asc  ;;
   63: len 30; hex 376635366438373962623761646237376564333062386637303162336537; asc 7f56d879bb7adb77ed30b8f701b3e7; (total 32 bytes);
   64: SQL NULL;
   65: len 12; hex 2b3331313537323030303737; asc +31157200077;;
   66: len 5; hex 6e6c2d4e4c; asc nl-NL;;
   67: len 30; hex 653366666331396463343665666639653730346339376363633631313335; asc e3ffc19dc46eff9e704c97ccc61135; (total 32 bytes);
   68: len 3; hex 455552; asc EUR;;
   69: len 10; hex 80000000010000000000; asc           ;;
   70: len 10; hex 80000000000004e603de; asc           ;;
   71: len 10; hex 800000000000041501c2; asc           ;;
   72: len 10; hex 800000000000040d00be; asc           ;;
   73: len 10; hex 80000000000000000000; asc           ;;
   74: len 10; hex 80000000000000da0294; asc           ;;
   75: len 10; hex 80000000000000090078; asc          x;;
   76: len 10; hex 80000000000000000000; asc           ;;
   77: len 10; hex 80000000000000000000; asc           ;;
   78: len 1; hex 81; asc  ;;
   79: SQL NULL;
   80: SQL NULL;
   81: SQL NULL;
   82: SQL NULL;
   83: SQL NULL;
   84: SQL NULL;
   85: len 1; hex 81; asc  ;;
   86: len 1; hex 80; asc  ;;
   87: SQL NULL;
   88: len 8; hex 8000000e479e008b; asc     G   ;;
   89: len 4; hex 53686f70; asc Shop;;
   90: len 8; hex 80000000264d010a; asc     &M  ;;


   *** (2) TRANSACTION:
   TRANSACTION 65364055536, ACTIVE 0 sec fetching rows
   mysql tables in use 2, locked 2
   LOCK WAIT 13 lock struct(s), heap size 1128, 24 row lock(s), undo log entries 5
   MySQL thread id 2967156, OS thread handle 139582238603008, query id 102330086604 255.78.105.31 shopify_writer executing
   /*action:query,api_client_id:119385423873,application:Shopify,capacity_scope:general,consistent_read_id:b98925b6-bc0e-4a7b-9314-c7b8cf6d9aa3,controller:admin/graphql,pod_id:265,request_id:9bae607f-9c80-44fc-b829-4c5c243140a5-1742914686,request_priority:medium,role:rw,shop_id:61331079307*/ SELECT /*+ MAX_EXECUTION_TIME(16700) */ `fulfillment_orders`.`id` AS t0_r0, `fulfillment_orders`.`shop_id` AS t0_r1, `fulfillment_orders`.`order_id` AS t0_r2, `fulfillment_orders`.`fulfillment_service_handle` AS t0_r3, `fulfillment_orders`.`status` AS t0_r4, `fulfillment_orders`.`requires_shipping` AS t0_r5, `fulfillment_orders`.`is_not_deleted` AS t0_r6, `fulfillment_orders`.`deleted_at` AS t0_r7, `fulfillment_orders`.`created_at` AS t0_r8, `fulfillment_orders`.`updated_at` AS t0_r9, `fulfillment_orders`.`happened_at` AS t0_r10, `fulfillment_orders`.`assigned_location_id` AS t0_r11, `fulfillment_orders`.`

   *** (2) HOLDS THE LOCK(S):
   RECORD LOCKS space id 6782 page no 6186770 n bits 80 index PRIMARY of table `shopify_shard_265`.`orders` trx id 65364055536 lock_mode X locks rec but not gap
   Record lock, heap no 12 PHYSICAL RECORD: n_fields 91; compact format; info bits 0
   0: len 8; hex 8000000e479e008b; asc     G   ;;
   1: len 8; hex 80000641f162810a; asc    A b  ;;
   2: len 6; hex 000f380055f0; asc   8 U ;;
   3: len 7; hex 02000008f52356; asc      #V;;
   4: len 8; hex 800013741791010a; asc    t    ;;
   5: len 8; hex 800013741790810a; asc    t    ;;
   6: len 30; hex 6c2e6f6569407368616e67686169686f74656c686f6c6c616e642e636f6d; asc l.oei@shanghaihotelholland.com;;
   7: SQL NULL;
   8: len 8; hex 99b632ead400a9d7; asc   2     ;;
   9: len 8; hex 99b632ee860c483f; asc   2   H?;;
   10: len 4; hex 800c6ba0; asc   k ;;
   11: SQL NULL;
   12: len 30; hex 353137326231613161616335633862376333313363656531393361313433; asc 5172b1a1aac5c8b7c313cee193a143; (total 32 bytes);
   13: SQL NULL;
   14: len 16; hex 73686f706966795f7061796d656e7473; asc shopify_payments;;
   15: len 1; hex 80; asc  ;;
   16: len 10; hex 800000000000041501c2; asc           ;;
   17: len 10; hex 800000000000040d00be; asc           ;;
   18: len 8; hex 0000000000000000; asc         ;;
   19: len 10; hex 80000000000000000000; asc           ;;
   20: len 1; hex 81; asc  ;;
   21: len 3; hex 455552; asc EUR;;
   22: len 4; hex 70616964; asc paid;;
   23: len 6; hex 646972656374; asc direct;;
   24: len 16; hex 23e298a031e298a20a2d2d2d207b7d0a; asc #   1    --- {} ;;
   25: len 1; hex 81; asc  ;;
   26: len 11; hex 756e66756c66696c6c6564; asc unfulfilled;;
   27: len 10; hex 80000000000000da0294; asc           ;;
   28: len 10; hex 80000000000004e603de; asc           ;;
   29: len 30; hex 5a324e774c575631636d39775a5331335a584e304e446f774d5570524e6c; asc Z2NwLWV1cm9wZS13ZXN0NDowMUpRNl; (total 58 bytes);
   30: len 1; hex 80; asc  ;;
   31: len 6; hex 383134393834; asc 814984;;
   32: SQL NULL;
   33: SQL NULL;
   34: len 30; hex 23e298a031e298a20a2d2d2d0a7365676d656e74436f6e663a20354f4267; asc #   1    --- segmentConf: 5OBg; (total 304 bytes);
   35: len 8; hex 80000937c414810a; asc    7    ;;
   36: SQL NULL;
   37: SQL NULL;
   38: len 10; hex 80000000000004690172; asc        i r;;
   39: len 30; hex 633566643134383535646166346665343534653938336631356566353834; asc c5fd14855daf4fe454e983f15ef584; (total 32 bytes);
   40: len 1; hex 80; asc  ;;
   41: len 10; hex 80000000000000090078; asc          x;;
   42: SQL NULL;
   43: SQL NULL;
   44: SQL NULL;
   45: len 8; hex 80002c553260010a; asc   ,U2`  ;;
   46: SQL NULL;
   47: len 1; hex 80; asc  ;;
   48: len 3; hex 623262; asc b2b;;
   49: len 6; hex 373231313632; asc 721162;;
   50: SQL NULL;
   51: SQL NULL;
   52: len 8; hex 99b632eacf0c5087; asc   2   P ;;
   53: SQL NULL;
   54: SQL NULL;
   55: SQL NULL;
   56: len 8; hex 80000000005e1aa1; asc      ^  ;;
   57: len 10; hex 80000000000004110140; asc          @;;
   58: len 10; hex 80000000000000000000; asc           ;;
   59: len 10; hex 80000000000000000000; asc           ;;
   60: len 8; hex 800000348e0b810a; asc    4    ;;
   61: len 1; hex 80; asc  ;;
   62: len 1; hex 81; asc  ;;
   63: len 30; hex 376635366438373962623761646237376564333062386637303162336537; asc 7f56d879bb7adb77ed30b8f701b3e7; (total 32 bytes);
   64: SQL NULL;
   65: len 12; hex 2b3331313537323030303737; asc +31157200077;;
   66: len 5; hex 6e6c2d4e4c; asc nl-NL;;
   67: len 30; hex 653366666331396463343665666639653730346339376363633631313335; asc e3ffc19dc46eff9e704c97ccc61135; (total 32 bytes);
   68: len 3; hex 455552; asc EUR;;
   69: len 10; hex 80000000010000000000; asc           ;;
   70: len 10; hex 80000000000004e603de; asc           ;;
   71: len 10; hex 800000000000041501c2; asc           ;;
   72: len 10; hex 800000000000040d00be; asc           ;;
   73: len 10; hex 80000000000000000000; asc           ;;
   74: len 10; hex 80000000000000da0294; asc           ;;
   75: len 10; hex 80000000000000090078; asc          x;;
   76: len 10; hex 80000000000000000000; asc           ;;
   77: len 10; hex 80000000000000000000; asc           ;;
   78: len 1; hex 81; asc  ;;
   79: SQL NULL;
   80: SQL NULL;
   81: SQL NULL;
   82: SQL NULL;
   83: SQL NULL;
   84: SQL NULL;
   85: len 1; hex 81; asc  ;;
   86: len 1; hex 80; asc  ;;
   87: SQL NULL;
   88: len 8; hex 8000000e479e008b; asc     G   ;;
   89: len 4; hex 53686f70; asc Shop;;
   90: len 8; hex 80000000264d010a; asc     &M  ;;


   *** (2) WAITING FOR THIS LOCK TO BE GRANTED:
   RECORD LOCKS space id 4257 page no 1902755 n bits 144 index PRIMARY of table `shopify_shard_265`.`fulfillment_orders` trx id 65364055536 lock mode S locks rec but not gap waiting
   Record lock, heap no 74 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
   0: len 8; hex 80000741c293010a; asc    A    ;;
   1: len 6; hex 000f37fda86b; asc   7  k;;
   2: len 7; hex 0200002b90244a; asc    + $J;;
   3: len 8; hex 0000000e479e008b; asc     G   ;;
   4: len 8; hex 00000641f162810a; asc    A b  ;;
   5: len 11; hex 7373742d6e6c2d70726f64; asc sst-nl-prod;;
   6: len 11; hex 696e5f70726f6772657373; asc in_progress;;
   7: len 1; hex 81; asc  ;;
   8: len 1; hex 81; asc  ;;
   9: SQL NULL;
   10: len 8; hex 99b632eae202a6dd; asc   2     ;;
   11: len 8; hex 99b632ee490e899a; asc   2 I   ;;
   12: len 5; hex 99b632eae2; asc   2  ;;
   13: len 8; hex 000000159487010a; asc         ;;
   14: len 22; hex 63616e63656c6c6174696f6e5f726571756573746564; asc cancellation_requested;;
   15: len 1; hex 80; asc  ;;
   16: len 5; hex 99b632e000; asc   2  ;;
   17: SQL NULL;
   18: len 30; hex 38306530626339312d326138652d343262342d386561332d323362616161; asc 80e0bc91-2a8e-42b4-8ea3-23baaa; (total 36 bytes);

   *** WE ROLL BACK TRANSACTION (1)
   ```
   You will see the `*** (1) TRANSACTION:` and `*** (2) TRANSACTION:` headings which each have SQL Statements a few
   lines underneath them. One of the SQL Statements will match the first SQL Statement I gave you and the other one
   should be different. The order isn't guaranteed, sometimes the SQL Statement I gave you will be under
   `*** (1) TRANSACTION:` and other times it may be under `*** (2) TRANSACTION:`. It's possible that the latest detected
   deadlock lock truncates the SQL Statements that are deadlocking. Do your best to identify which one is not the one I
   provided. If you're unsure you can ask me to verify but usually it should be fairly obvious and I don't want to be
   prompted about this if I don't need to be.
7. Show me the two SQL Statements that are deadlocked, listing the first SQL Statement I provided for you first,
   followed by the second SQL Statement you discovered from the latest deadlock detected log. Format these SQL
   Statements and their comments in a nice way that is easy to understand at a glance. An example of this output looks
   like this:
   The SQL Statement from the Bugsnag exception
   ```sql
   /*
     action:query,
     api_client_id:34646425601,
     application:Shopify,
     capacity_scope:general,
     consistent_read_id:7f805a65-7c44-4f5b-8d2f-1bf0a534accc,
     controller:admin/graphql,
     pod_id:296,
     request_id:2e084b91-c94c-42ed-a7ff-540bb7dfaa8d-1742945121,
     request_priority:medium,
     role:rw,
     shop_id:68267966761
   */
   UPDATE `orders`
   SET `orders`.`updated_at` = '2025-03-25 23:25:21.390250'
   WHERE `orders`.`shop_id` = 68267966761
     AND `orders`.`id` = 6378332422441
   ```

   The SQL Statement that is deadlocking
   ```sql
   /*
     action:query,
     api_client_id:119385423873,
     application:Shopify,
     capacity_scope:general,
     consistent_read_id:b98925b6-bc0e-4a7b-9314-c7b8cf6d9aa3,
     controller:admin/graphql,
     pod_id:265,
     request_id:9bae607f-9c80-44fc-b829-4c5c243140a5-1742914686,
     request_priority:medium,
     role:rw,
     shop_id:61331079307
   */
   SELECT /*+ MAX_EXECUTION_TIME(16700) */
     `fulfillment_orders`.`id` AS t0_r0,
     `fulfillment_orders`.`shop_id` AS t0_r1,
     `fulfillment_orders`.`order_id` AS t0_r2,
     `fulfillment_orders`.`fulfillment_service_handle` AS t0_r3,
     `fulfillment_orders`.`status` AS t0_r4,
     `fulfillment_orders`.`requires_shipping` AS t0_r5,
     `fulfillment_orders`.`is_not_deleted` AS t0_r6,
     `fulfillment_orders`.`deleted_at` AS t0_r7,
     `fulfillment_orders`.`created_at` AS t0_r8,
     `fulfillment_orders`.`updated_at` AS t0_r9,
     `fulfillment_orders`.`happened_at` AS t0_r10,
     `fulfillment_orders`.`assigned_location_id` AS t0_r11,
     `fulfillment_orders`.`
   ```

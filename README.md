# linebot-demo

## Start development
1. Start development server
```
$ ./bin/dev
```

2. Start Redis server at default port 6379 in another terminal
```
$ redis-server
```

### Route message from line chatbot to the Rails app
3. Assume you have [ngrok](https://ngrok.com/). We need to use it to proxy our development server for Line messaging webhook. Run following command in a separated terminal
```
$ ngrok http 3000
```

4. Assume you are able to access Line developer console for this project, go to Line Official Account manager page, then go to Settings > Messaging API then paste the ngrok proxy URL to  Webhook URL input. The value should be something like `https://some-token.ngrok-free.app/linebot` 


## Requirements
1. เพิ่ม linebot เข้าไปในห้อง chat ที่มีสมาชิกเดิมอยู่แล้ว
2. ให้ linebot match ข้อความ และส่งข้อความตอบกลับตามเงื่อนไขดังนี้

| match | response with |
| ---- | ---- |
| `ppx <number>` | got x <number> |
| `ppy <number>` | got y <number> |

3. มีช่องทางให้ user(admin) เข้าไปเพิ่มหรือแก้ไขคำสั่งเราต้องการให้ bot match คำสั่งให้

### Test cases
| Input Message | Expected Result |
| ---- | ---- |
| ppx 100     | got x 100 |
| ppx  100    | got x 100 |
| ppx 100.    | got x 100 |
| ppx 100 abc | got x 100 |
| ppx 100 200 | got x 100 |
| ppx          | do nothing |
| ppx abc100.  | do nothing |
| ppx abc 100. | do nothing |
| ppx 100abc`  | do nothing |

# linebot-demo

## Start development
1. Start development server
`$ ./bin/dev`

2. Start Redis server at default port 6379 in another terminal
`$ redis-server`

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

# linebot-demo

## Requirements
1. เพิ่ม linebot เข้าไปในห้อง chat ที่มีสมาชิกเดิมอยู่แล้ว
2. ให้ linebot match ข้อความ และส่งข้อความตอบกลับตามเงื่อนไขดังนี้
| match | response with |
| --- | --- |
| `ppx <number>` | got x <number> |
| `ppy <number>` | got y <number> |

3. มีช่องทางให้ user(admin) เข้าไปเพิ่มหรือแก้ไขคำสั่งเราต้องการให้ bot match คำสั่งให้

### Test cases
`ppx 100`       # got x 100
`ppx  100`      # got x 100
`ppx 100.`      # got x 100
`ppx 100 abc`   # got x 100
`ppx 100 200`   # got x 100
`ppx`           # do nothing
`ppx abc100.`   # do nothing
`ppx abc 100.`  # do nothing
`ppx 100abc`    # do nothing

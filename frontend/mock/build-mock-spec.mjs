// Tạo bản sao contract có dữ liệu mẫu cho mock Prism: mock/.generated/openapi.yaml
// Chạy tự động trong `npm run mock`; sửa dữ liệu mẫu ở mock/examples.js.
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { parse, stringify } from 'yaml'
import { SCHEMA_EXAMPLES } from './examples.js'

const here = dirname(fileURLToPath(import.meta.url))
const source = resolve(here, '../../docs/api/openapi.yaml')
const target = resolve(here, '.generated/openapi.yaml')

const spec = parse(readFileSync(source, 'utf8'))
for (const [name, example] of Object.entries(SCHEMA_EXAMPLES)) {
  const schema = spec.components?.schemas?.[name]
  if (!schema) throw new Error(`Không tìm thấy schema ${name} trong openapi.yaml`)
  schema.example = example
}

mkdirSync(dirname(target), { recursive: true })
writeFileSync(target, stringify(spec))
console.log(`Mock spec: ${Object.keys(SCHEMA_EXAMPLES).length} schema có dữ liệu mẫu -> ${target}`)

<style lang="sass">
.Perfor
    .q-table__container:last-child
        border-radius: 0 0 4px 4px
    &-table
        &.performance
        &.not-performance
    .q-table__top
        .q-table__control
            text-align: center
            width: 100%
            .q-table__title
                width: 100%
                font-size: 16px
                font-weight: 600
                text-align: center
    th
        white-space: pre
        text-align: center
        font-weight: 600
        color: white
        background-color: #006eaa

    // Строки, разделяющие секции таблицы
    .table-row-section
        text-decoration: underline
        text-align: center

    // Именованные строки
    .table-row-sub-total
        font-weight: 600
    .table-row-total
        font-weight: 600
        background-color: #e0e0e0
</style>
<template>
<section>
<template>
  <div class="q-pa-md q-gutter-sm">
    <q-tree
      :nodes="customize"
      node-key="label"
      default-expand-all
      :selected.sync="selected"
    >
      <template v-slot:default-header="prop">
        <div class="row items-center">
          <q-icon :name="prop.node.icon || 'share'" color="orange" size="28px" class="q-mr-sm" v-on:click="seen = !seen"/>
          <div class="text-weight-bold text-black" v-on:click="seen = !seen">{{ prop.node.label }}</div>
        </div>
      </template>
      <template v-slot:default-body="prop">
        <div v-if="prop.node.body">
          <template>
            <div v-if="seen" class="Performan">
              <q-table
                v-model="separator"
                class="Perfor no-shadow"
                style="border-radius: 0 0 4px 4px;border: 1px solid rgba(0,0,0,0.12);border-top-width: 1;width:100%"
                virtual-scroll
                autoRowHeight
                :minRowHeight="16"
                :maxRowHeight="30"
                :pagination.sync="pagination"
                :rows-per-page-options="[0]"
                :virtual-scroll-sticky-size-start="48"
                row-key="index"
                :separator="separator"
                title="Численность работников по профессиям за Декабрь 2019"
                :data="data"
                :columns="columns"
                hide-bottom
                no-shadow
              />
            </div>
          </template>
        </div>
      </template>
    </q-tree>
  </div>
</template>
</section>
</template>

<script>
const seed = [
  {
    c: '35,76',
    c1: '1105',
    c2: '1155',
    c3: '118 260,56',
    name: 'Бетонщик 3 разряда',
    calories: 159,
    calories1: 1,
    calories2: 9,
    calories3: 19,
    calories4: 1,
    calories5: 19,
    calories6: 19
  },
  {
    c: '35,76',
    c1: '1105',
    c2: '1155',
    c3: '118 260,56',
    name: 'Электросварщик ручной сварки 5 разряда',
    calories: 159,
    calories1: 15,
    calories2: 159,
    calories3: 19,
    calories4: 159,
    calories5: 9,
    calories6: 1
  },
  {
    c: '35,76',
    c1: '1105',
    c2: '1155',
    c3: '118 260,56',
    name: 'Монтажник по монтажу стальных и железобетонных конструкций 4 разряда',
    calories: 159,
    calories1: 19,
    calories2: 59,
    calories3: 19,
    calories4: 19,
    calories5: 159,
    calories6: 159
  },
  {
    c: '35,76',
    c1: '1105',
    c2: '1155',
    c3: '118 260,56',
    name: 'Каменщик 5 разряда',
    calories: 9,
    calories1: 19,
    calories2: 19,
    calories3: 19,
    calories4: 159,
    calories5: 432,
    calories6: 59
  }
]

// we generate lots of rows here
let data = []
for (let i = 0; i < 1; i++) {
  data = data.concat(seed.slice(0).map(r => ({ ...r })))
}
data.forEach((row, index) => {
  row.index = index+1
})

// we are not going to change this array,
// so why not freeze it to avoid Vue adding overhead
// with state change detection
Object.freeze(data)
export default {
  data () {
    return {
      selected: null,
      seen: false,
      data,
      separator: 'cell',
      pagination: {
        rowsPerPage: 0
      },

      columns: [
        {
          name: 'index',
          label: '№\n п.п.',
          field: 'index',
          align: 'center',
        },
        {
          name: 'name',
          required: true,
          label: 'Профессия, должность',
          align: 'left',
          field: row => row.name,
          style: '',
          format: val => `${val}`,
          sortable: true
        },
         { name: 'c', align: 'center', label: '     Тариф', field: 'c', sortable: true, style: 'text-align: center;' },
         { name: 'c1', align: 'center', label: 'Итог\n     чел.дней', field: 'c1', sortable: true, style: 'text-align: center;' },
         { name: 'c2', align: 'center', label: 'Итог\n      чел.час', field: 'c2', sortable: true, style: 'text-align: center;' },
         { name: 'c3', align: 'center', label: 'Тарифная\n      часть', field: 'c3', sortable: true, style: 'text-align: center;' },
        { name: 'calories', align: 'center', label: '      1', field: 'calories', sortable: true, style: 'text-align: right;' },
        { name: 'calories1', align: 'center', label: '      2', field: 'calories1', sortable: true, style: 'text-align: right;' },
        { name: 'calories2', align: 'center', label: '      3', field: 'calories2', sortable: true, style: 'text-align: right;' },
        { name: 'calories3', align: 'center', label: '      4', field: 'calories3', sortable: true, style: 'text-align: right;' },
        { name: 'calories4', align: 'center', label: '      5', field: 'calories4', sortable: true, style: 'text-align: right;' },
        { name: 'calories5', align: 'center', label: '      6', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories6', align: 'center', label: '      7', field: 'calories6', sortable: true, style: 'text-align: right;' },
        { name: 'calories7', align: 'center', label: '      8', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories8', align: 'center', label: '      9', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories9', align: 'center', label: '     10', field: 'calories4', sortable: true, style: 'text-align: right;' },
        { name: 'calories10', align: 'center', label: '     11', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     12', field: 'calories3', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     13', field: 'calories3', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     14', field: 'calories2', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     15', field: 'calories1', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     16', field: 'calories2', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     17', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     18', field: 'calories4', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     19', field: 'calories3', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     20', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     21', field: 'calories2', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     22', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     23', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     24', field: 'calories1', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     25', field: 'calories2', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     26', field: 'calories3', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     27', field: 'calories4', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     28', field: 'calories5', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     29', field: 'calories2', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     30', field: 'calories1', sortable: true, style: 'text-align: right;' },
        { name: 'calories11', align: 'center', label: '     31', field: 'calories5', sortable: true, style: 'text-align: right;' }
      ],
      customize: [
        {
          label: 'СУ Мостострой-11',
          header: 'root',
          icon: 'home_work',
          children: [
            {
              label: 'Школа на 1200 учебных мест в районе улиц Николая Зелинского — Дмитрия Менделеева г.Тюмень',
              icon: 'input',
              header: 'generic',
              body: 'story'
            }
          ]
        }
      ]
    }
  }
}
</script>

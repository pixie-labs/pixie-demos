(this["webpackJsonpreact-table-demo"]=this["webpackJsonpreact-table-demo"]||[]).push([[0],[,,,,function(e,t,a){e.exports={ColumnSelector:"ColumnSelector_ColumnSelector__1LtuL",Label:"ColumnSelector_Label__Znnco",Checkbox:"ColumnSelector_Checkbox__3CcNf"}},function(e,t,a){e.exports={Table:"Table_Table__gTzsf",ResizeHandle:"Table_ResizeHandle__1LDIp",ResizeHandleActive:"Table_ResizeHandleActive__-UEDL"}},,,function(e,t,a){e.exports={Filter:"Filter_Filter__3qIm_"}},,,,,,function(e,t,a){},,,,,function(e,t,a){},function(e,t,a){},function(e,t,a){"use strict";a.r(t);var n=a(2),c=a.n(n),r=a(7),s=a.n(r),l=(a(14),a(0));function o(e){return e[Math.floor(Math.random()*e.length)]}function i(e,t){var a=o(["200 OK","301 Moved Permanently","404 Not Found","418 I'm a teapot","501 Not Implemented"]);return{timestamp:e+Math.floor(Math.random()*(t-e)),latencyMs:5+Math.floor(150*Math.random()),endpoint:"/user/"+o(["bendy-badger","happy-hippo","giant-ape","grumpy-groundhog","phlegmatic-pheasant"]),status:a}}var u=[{Header:"Timestamp",Cell:function(e){var t=e.value;return Object(l.jsx)("span",{className:"Cell-Timestamp",children:Object(l.jsx)("span",{children:new Date(t).toLocaleString()})})},accessor:"timestamp"},{Header:"Latency",Cell:function(e){var t=e.value,a="bad";return t<=50?a="good":t<=100&&(a="weak"),Object(l.jsx)("span",{className:"Cell-Latency ".concat(a),children:t})},accessor:"latencyMs"},{Header:"Endpoint",Cell:function(e){var t=e.value;return Object(l.jsx)("span",{className:"Cell-Endpoint",children:t})},accessor:"endpoint"},{Header:"Status",Cell:function(e){var t=e.value,a=+t.split(" ")[0],n=500;return a<300?n=200:a<400?n=300:a<500&&(n=400),Object(l.jsx)("span",{className:"Cell-StatusCode range-".concat(n),children:t})},accessor:"status"}];var d=a(1),b=a(5),j=a.n(b),p=a(9),h=a(8),m=a.n(h);function O(e){var t=e.onChange,a=n.useState(""),c=Object(p.a)(a,2),r=c[0],s=c[1],o=n.useCallback((function(e){var a=e.target.value.trim();s(a),t(a)}),[t]);return Object(l.jsx)("div",{className:m.a.Filter,children:Object(l.jsx)("input",{type:"text",value:r,placeholder:"Search rows...",onChange:o})})}var x=a(4),v=a.n(x);function f(e){var t=e.columns;return Object(l.jsxs)("div",{className:v.a.ColumnSelector,children:[Object(l.jsx)("div",{className:v.a.Label,children:"Show Columns:"}),Object(l.jsx)("div",{className:v.a.Checkboxes,children:t.map((function(e){return Object(l.jsx)("div",{className:v.a.Checkbox,children:Object(l.jsxs)("label",{children:[Object(l.jsx)("input",Object(d.a)({type:"checkbox"},e.getToggleHiddenProps()))," ".concat(e.Header)]})},e.id)}))})]})}var g=a(3);a(19);function C(e){var t=e.data,a=t.columns,n=t.data,c=Object(g.useTable)({columns:a,data:n},g.useFlexLayout,g.useGlobalFilter,g.useSortBy,g.useResizeColumns),r=c.getTableProps,s=c.getTableBodyProps,o=c.headerGroups,i=c.rows,u=c.allColumns,b=c.prepareRow,p=c.setGlobalFilter;return Object(l.jsxs)("div",{className:"Table-root",children:[Object(l.jsxs)("header",{children:[Object(l.jsx)(f,{columns:u}),Object(l.jsx)(O,{onChange:p})]}),Object(l.jsxs)("table",Object(d.a)(Object(d.a)({},r()),{},{className:j.a.Table,children:[Object(l.jsx)("thead",{children:o.map((function(e){return Object(l.jsx)("tr",Object(d.a)(Object(d.a)({},e.getHeaderGroupProps()),{},{children:e.headers.map((function(e){return Object(l.jsxs)("th",Object(d.a)(Object(d.a)({},e.getHeaderProps()),{},{children:[Object(l.jsxs)("div",Object(d.a)(Object(d.a)({},e.getSortByToggleProps()),{},{children:[e.render("Header"),Object(l.jsx)("span",{children:e.isSorted?e.isSortedDesc?" \ud83d\udd3d":" \ud83d\udd3c":""})]})),Object(l.jsx)("div",Object(d.a)(Object(d.a)({},e.getResizerProps()),{},{className:[j.a.ResizeHandle,e.isResizing&&j.a.ResizeHandleActive].filter((function(e){return e})).join(" "),children:"\u22ee"}))]}))}))}))}))}),Object(l.jsx)("tbody",Object(d.a)(Object(d.a)({},s()),{},{children:i.map((function(e){return b(e),Object(l.jsx)("tr",Object(d.a)(Object(d.a)({},e.getRowProps()),{},{children:e.cells.map((function(e){return Object(l.jsx)("td",Object(d.a)(Object(d.a)({},e.getCellProps()),{},{children:e.render("Cell")}))}))}))}))}))]}))]})}a(20);var _=function(){var e=function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:20,t=n.useMemo((function(){var t=Date.now(),a=t-6048e5;return Array(e).fill(0).map((function(){return i(a,t)}))}),[e]);return{columns:u,data:t}}(100);return Object(l.jsx)("main",{className:"App",children:Object(l.jsx)(C,{data:e})})},S=function(e){e&&e instanceof Function&&a.e(3).then(a.bind(null,22)).then((function(t){var a=t.getCLS,n=t.getFID,c=t.getFCP,r=t.getLCP,s=t.getTTFB;a(e),n(e),c(e),r(e),s(e)}))};s.a.render(Object(l.jsx)(c.a.StrictMode,{children:Object(l.jsx)(_,{})}),document.getElementById("root")),S()}],[[21,1,2]]]);
//# sourceMappingURL=main.8d5fe1bc.chunk.js.map